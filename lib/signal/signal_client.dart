import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:fyp_chat_app/dto/update_keys_dto.dart';
import 'package:fyp_chat_app/models/key_bundle.dart';
import 'package:fyp_chat_app/models/message.dart';
import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/models/pre_key.dart';
import 'package:fyp_chat_app/models/signed_pre_key.dart';
import 'package:fyp_chat_app/models/user.dart';
import 'package:fyp_chat_app/network/devices_api.dart';
import 'package:fyp_chat_app/network/events_api.dart';
import 'package:fyp_chat_app/network/account_api.dart';
import 'package:fyp_chat_app/network/keys_api.dart';
import 'package:fyp_chat_app/network/users_api.dart';
import 'package:fyp_chat_app/signal/device_helper.dart';
import 'package:fyp_chat_app/storage/contact_store.dart';
import 'package:fyp_chat_app/storage/disk_identity_key_store.dart';
import 'package:fyp_chat_app/storage/disk_pre_key_store.dart';
import 'package:fyp_chat_app/storage/disk_session_store.dart';
import 'package:fyp_chat_app/storage/disk_signed_pre_key_store.dart';
import 'package:fyp_chat_app/storage/message_store.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:fyp_chat_app/models/send_message_dao.dart';

class SignalClient {
  SignalClient._();

  static final SignalClient _instance = SignalClient._();

  factory SignalClient() {
    return _instance;
  }

  Future<void> initialize() async {
    await registerDevice();
    await generateAndStoreKeys();
  }

  Future<void> registerDevice() async {
    final dto = await DeviceInfoHelper().initDevice();
    final device = await DevicesApi().addDevice(dto);
    await DeviceInfoHelper().setDeviceId(device.deviceId);
  }

  Future<void> generateAndStoreKeys() async {
    // generate keys
    final identityKeyPair = generateIdentityKeyPair();
    final oneTimeKeys = generatePreKeys(0, 110);
    final signedPreKey = generateSignedPreKey(identityKeyPair, 0);

    // store keys
    await DiskIdentityKeyStore().storeIdentityKeyPair(identityKeyPair);
    for (var p in oneTimeKeys) {
      await DiskPreKeyStore().storePreKey(p.id, p);
    }
    await DiskSignedPreKeyStore()
        .storeSignedPreKey(signedPreKey.id, signedPreKey);

    // upload keys to Server
    final dto = UpdateKeysDto(
      (await DeviceInfoHelper().getDeviceId())!,
      identityKey: base64.encode(identityKeyPair.getPublicKey().serialize()),
      oneTimeKeys:
          oneTimeKeys.map((e) => PreKey.fromPreKeyRecord(e).toDto()).toList(),
      signedPreKey: SignedPreKey.fromSignedPreKeyRecord(signedPreKey).toDto(),
    );
    await KeysApi().updateKeys(dto);
  }

  Future<void> sendMessage(String recipientUserId, String content) async {
    // TODO: implement this
    // use SendMessageDao.toDto(), EventsApi(), etc
    final senderDeviceId = await DeviceInfoHelper().getDeviceId();
    if (senderDeviceId == null) {
      throw Exception('Sender Device Id is null');
    }

    final keyList = await KeysApi().getAllKeyBundle(recipientUserId);
    final keyBundle = KeyBundle.fromDto(keyList);
    DateTime sentTime = DateTime.now();

    for (final key in keyBundle.deviceKeyBundles) {
      final remoteAddress = SignalProtocolAddress(
        recipientUserId,
        key.deviceId,
      );
      // check session is existed or not
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
        final oneTimeKey = key.oneTimeKey;
        final signedPreKey = key.signedPreKey;
        final retrievedPreKey = PreKeyBundle(
          await DiskIdentityKeyStore().getLocalRegistrationId(),
          senderDeviceId,
          oneTimeKey?.id,
          oneTimeKey?.key,
          signedPreKey.id,
          signedPreKey.key,
          signedPreKey.signature,
          keyBundle.identityKey,
        );
        await sessionBuilder.processPreKeyBundle(retrievedPreKey);
      }
      // encrypt message
      final remoteSessionCipher = SessionCipher(
        DiskSessionStore(),
        DiskPreKeyStore(),
        DiskSignedPreKeyStore(),
        DiskIdentityKeyStore(),
        remoteAddress,
      );
      final ciphertext = await remoteSessionCipher
          .encrypt(Uint8List.fromList(utf8.encode(content)));

      // send message use EventsApi()
      final message = SendMessageDao(senderDeviceId, recipientUserId,
              key.deviceId, ciphertext as PreKeySignalMessage, sentTime)
          .toDto();
      //mark first message sent time only

      EventsApi().sendMessage(message);
    }

    // save message to disk
    final myAccount = await AccountApi().getMe();
    final plainMessage = PlainMessage(
      senderUserId: myAccount.userId,
      senderUsername: myAccount.username,
      content: content,
      sentAt: sentTime,
    );

    final messageId = await MessageStore().storeMessage(plainMessage);
    plainMessage.id = messageId;
  }

  Future<PlainMessage> processMessage(Message message) async {
    final User user;
    // try to find user in disk
    final userInDisk =
        await ContactStore().getContactById(message.senderUserId);
    if (userInDisk != null) {
      user = userInDisk;
    } else {
      // get user from server
      final userDto = await UsersApi().getUserById(message.senderUserId);
      user = User.fromDto(userDto);
    }
    // set up address
    final remoteAddress = SignalProtocolAddress(
      message.senderUserId,
      message.senderDeviceId,
    );
    // check if session exist
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
          .getKeyBundle(message.senderUserId, message.senderDeviceId);
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
    // decrypt message
    final remoteSessionCipher = SessionCipher(
      DiskSessionStore(),
      DiskPreKeyStore(),
      DiskSignedPreKeyStore(),
      DiskIdentityKeyStore(),
      remoteAddress,
    );

    final plaintext =
        utf8.decode(await remoteSessionCipher.decrypt(message.content));

    final plainMessage = PlainMessage(
      senderUserId: message.senderUserId,
      senderUsername: user.username,
      content: plaintext,
      sentAt: message.sentAt,
    );

    // save message to disk
    final messageId = await MessageStore().storeMessage(plainMessage);
    plainMessage.id = messageId;
    return plainMessage;
  }
}
