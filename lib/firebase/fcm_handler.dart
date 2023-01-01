import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp_chat_app/dto/message_dto.dart';
import 'package:fyp_chat_app/models/key_bundle.dart';
import 'package:fyp_chat_app/network/keys_api.dart';
import 'package:fyp_chat_app/network/users_api.dart';
import 'package:fyp_chat_app/signal/device_helper.dart';
import 'package:fyp_chat_app/storage/disk_identity_key_store.dart';
import 'package:fyp_chat_app/storage/disk_pre_key_store.dart';
import 'package:fyp_chat_app/storage/disk_session_store.dart';
import 'package:fyp_chat_app/storage/disk_signed_pre_key_store.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import '../models/message.dart' as message_model;

class FCMHandler {
  static const channelId = 'fcm_channel';
  static const channelName = 'FCM Notifications';
  static const channelDescription = 'This channel is used for FCM messages.';

  static Future<void> onForegroundMessage(RemoteMessage message) async {
    // TODO: skip if the sender is the one currently chatting with
    // instead notify update on the chat screen
    _handleMessage(message);
  }

  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    _handleMessage(message);
  }

  // user click on notification to open app when app is in background
  static Future<void> onMessageOpenedApp(RemoteMessage message) async {
    _handleMessage(message);
  }

  static Future<void> _handleMessage(RemoteMessage remoteMessage) async {
    final messageDto = MessageDto.fromJson(remoteMessage.data);
    final message = message_model.Message.fromDto(messageDto);
    // TODO: existing contacts should be cached
    final user = await UsersApi().getUserById(messageDto.senderUserId);
    final remoteAddress = SignalProtocolAddress(
      user.username,
      message.senderDeviceId,
    );
    final containsSession =
        await DiskSessionStore().containsSession(remoteAddress);
    if (!containsSession) {
      // init session
      final sessionBuilder = SessionBuilder(
        DiskSessionStore(),
        DiskPreKeyStore(),
        DiskSignedPreKeyStore(),
        DiskIdentityKeyStore(),
        remoteAddress,
      );
      final keyBundleDto = await KeysApi()
          .getKeyBundle(messageDto.senderUserId, message.senderDeviceId);
      final keyBundle = KeyBundle.fromDto(keyBundleDto);
      final oneTimeKey = keyBundle.deviceKeyBundles[0].oneTimeKey;
      final signedPreKey = keyBundle.deviceKeyBundles[0].signedPreKey;
      final retrievedPreKey = PreKeyBundle(
        await DiskIdentityKeyStore().getLocalRegistrationId(),
        (await DeviceInfoHelper().getDeviceId())!,
        oneTimeKey?.id,
        oneTimeKey?.key,
        signedPreKey.id,
        signedPreKey.key,
        signedPreKey.signature,
        keyBundle.identityKey,
      );
      await sessionBuilder.processPreKeyBundle(retrievedPreKey);
    }

    final remoteSessionCipher = SessionCipher(
      DiskSessionStore(),
      DiskPreKeyStore(),
      DiskSignedPreKeyStore(),
      DiskIdentityKeyStore(),
      remoteAddress,
    );

    final plaintext =
        utf8.decode(await remoteSessionCipher.decrypt(message.content));

    FlutterLocalNotificationsPlugin().show(
        message.hashCode,
        user.username,
        plaintext.toString(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            importance: Importance.max,
          ),
        ));
  }
}
