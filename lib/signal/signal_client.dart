import 'dart:convert';
import 'dart:typed_data';

import 'package:fyp_chat_app/dto/update_keys_dto.dart';
import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:fyp_chat_app/models/key_bundle.dart';
import 'package:fyp_chat_app/models/message.dart';
import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/models/pre_key.dart';
import 'package:fyp_chat_app/models/received_plain_message.dart';
import 'package:fyp_chat_app/models/signed_pre_key.dart';
import 'package:fyp_chat_app/models/user.dart';
import 'package:fyp_chat_app/network/devices_api.dart';
import 'package:fyp_chat_app/network/events_api.dart';
import 'package:fyp_chat_app/network/account_api.dart';
import 'package:fyp_chat_app/network/keys_api.dart';
import 'package:fyp_chat_app/network/users_api.dart';
import 'package:fyp_chat_app/signal/device_helper.dart';
import 'package:fyp_chat_app/storage/account_store.dart';
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
      identityKey: identityKeyPair.getPublicKey().encodeToString(),
      oneTimeKeys:
          oneTimeKeys.map((e) => PreKey.fromPreKeyRecord(e).toDto()).toList(),
      signedPreKey: SignedPreKey.fromSignedPreKeyRecord(signedPreKey).toDto(),
    );
    await KeysApi().updateKeys(dto);
  }

  Future<PlainMessage> sendMessage(
      String recipientUserId, String content) async {
    final senderDeviceId = await DeviceInfoHelper().getDeviceId();
    if (senderDeviceId == null) {
      throw Exception('Sender Device Id is null');
    }

    final keyList = await KeysApi().getAllKeyBundle(recipientUserId);
    final keyBundle = KeyBundle.fromDto(keyList);
    DateTime sentTime = DateTime.now();

    await Future.wait(keyBundle.deviceKeyBundles.map(
      (deviceKeyBundle) async {
        final remoteAddress = SignalProtocolAddress(
          recipientUserId,
          deviceKeyBundle.deviceId,
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
          final oneTimeKey = deviceKeyBundle.oneTimeKey;
          final signedPreKey = deviceKeyBundle.signedPreKey;
          final retrievedPreKey = PreKeyBundle(
            deviceKeyBundle.registrationId,
            deviceKeyBundle.deviceId,
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
        final cipherText = await remoteSessionCipher
            .encrypt(Uint8List.fromList(utf8.encode(content)));

        // send message use EventsApi()
        final message = SendMessageDao(
          senderDeviceId,
          recipientUserId,
          deviceKeyBundle.deviceId,
          cipherText as PreKeySignalMessage,
          sentTime,
        ).toDto();
        //mark first message sent time only

        await EventsApi().sendMessage(message);
      },
    ));

    // save message to disk
    final myAccount =
        await AccountStore().getAccount() ?? await AccountApi().getMe();
    final plainMessage = PlainMessage(
      senderUserId: myAccount.userId,
      recipientUserId: recipientUserId,
      content: content,
      sentAt: sentTime,
    );

    final messageId = await MessageStore().storeMessage(plainMessage);
    plainMessage.id = messageId;

    return plainMessage;
  }

  Future<ReceivedPlainMessage?> processMessage(Message message) async {
    final me = await AccountStore().getAccount();
    if (me == null) {
      return null; // user not yet login (tho it should not happen)
    }
    final User sender;
    // try to find user in disk
    final senderInDisk =
        await ContactStore().getContactById(message.senderUserId);
    if (senderInDisk != null) {
      sender = senderInDisk;
    } else {
      // get user from server
      final userDto = await UsersApi().getUserById(message.senderUserId);
      sender = User.fromDto(userDto);
    }
    // set up address
    final remoteAddress = SignalProtocolAddress(
      message.senderUserId,
      message.senderDeviceId,
    );
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
      senderUserId: sender.userId,
      recipientUserId: me.userId,
      content: plaintext,
      sentAt: message.sentAt,
    );

    // save message to disk
    final messageId = await MessageStore().storeMessage(plainMessage);
    plainMessage.id = messageId;

    final receivedPlainMessage = ReceivedPlainMessage(
      sender: sender,
      message: plainMessage,
    );
    return receivedPlainMessage;
  }
}
