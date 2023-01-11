import 'dart:convert';
import 'dart:typed_data';

import 'package:fyp_chat_app/dto/account_dto.dart';
import 'package:fyp_chat_app/dto/update_keys_dto.dart';
import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/key_bundle.dart';
import 'package:fyp_chat_app/models/message.dart';
import 'package:fyp_chat_app/models/message_to_server.dart';
import 'package:fyp_chat_app/models/one_to_one_chat.dart';
import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/models/pre_key.dart';
import 'package:fyp_chat_app/models/received_plain_message.dart';
import 'package:fyp_chat_app/models/signed_pre_key.dart';
import 'package:fyp_chat_app/models/user.dart';
import 'package:fyp_chat_app/network/devices_api.dart';
import 'package:fyp_chat_app/network/events_api.dart';
import 'package:fyp_chat_app/network/keys_api.dart';
import 'package:fyp_chat_app/network/users_api.dart';
import 'package:fyp_chat_app/signal/device_helper.dart';
import 'package:fyp_chat_app/storage/account_store.dart';
import 'package:fyp_chat_app/storage/chatroom_store.dart';
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

  Future<void> _establishSession(
      String recipientUserId, KeyBundle keyBundle) async {
    await Future.wait(keyBundle.deviceKeyBundles.map((deviceKeyBundle) async {
      final remoteAddress = SignalProtocolAddress(
        recipientUserId,
        deviceKeyBundle.deviceId,
      );
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
      // store session
      await sessionBuilder.processPreKeyBundle(retrievedPreKey);
    }));
  }

  Future<MessageToServer> generateMessageToServer(
    String recipientUserId,
    int deviceId,
    String content,
  ) async {
    final remoteAddress = SignalProtocolAddress(
      recipientUserId,
      deviceId,
    );
    // load session to get reg id
    final session = await DiskSessionStore().loadSession(remoteAddress);
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

    return MessageToServer(
      cipherTextType: cipherText.getType(),
      recipientDeviceId: deviceId,
      recipientRegistrationId: session.sessionState.remoteRegistrationId,
      content: cipherText,
    );
  }

  Future<void> _sendMessage(
    int senderDeviceId,
    String recipientUserId,
    String chatroomId,
    String content,
    DateTime sentAt,
  ) async {
    // check if already establish session
    final remotePrimaryAddress = SignalProtocolAddress(
      recipientUserId,
      1, // device#1 is primary device
    );

    final containsSession =
        await DiskSessionStore().containsSession(remotePrimaryAddress);

    if (!containsSession) {
      final keyList = await KeysApi().getAllKeyBundle(recipientUserId);
      final keyBundle = KeyBundle.fromDto(keyList);

      await _establishSession(recipientUserId, keyBundle);
    }

    final deviceIds =
        await DiskSessionStore().getSubDeviceSessions(recipientUserId);

    final messages = await Future.wait(
      [1, ...deviceIds].map((deviceId) async =>
          generateMessageToServer(recipientUserId, deviceId, content)),
    );

    // send message use EventsApi()
    final message = SendMessageDao(
      senderDeviceId: senderDeviceId,
      recipientUserId: recipientUserId,
      chatroomId: chatroomId,
      messages: messages,
      sentAt: sentAt,
    ).toDto();

    final response = await EventsApi().sendMessage(message);

    // delete removed device (no need wait)
    Future.wait(
      response.removedDeviceIds.map(
        (id) async => await DiskSessionStore().deleteSession(
          SignalProtocolAddress(
            recipientUserId,
            id,
          ),
        ),
      ),
    );

    // revoke session for updated and new devices
    final messagesRetry = await Future.wait(
      [...response.misMatchDeviceIds, ...response.missingDeviceIds]
          .map((deviceId) async {
        final keys = await KeysApi().getKeyBundle(recipientUserId, deviceId);
        final keyBundle = KeyBundle.fromDto(keys);
        await _establishSession(recipientUserId, keyBundle);

        return generateMessageToServer(recipientUserId, deviceId, content);
      }),
    );

    final messageRetry = SendMessageDao(
      senderDeviceId: senderDeviceId,
      recipientUserId: recipientUserId,
      chatroomId: chatroomId,
      messages: messagesRetry,
      sentAt: sentAt,
    ).toDto();

    await EventsApi().sendMessage(message);
  }

  Future<PlainMessage> sendMessageToChatroom(
    AccountDto me, // pass me to speed up process
    Chatroom chatroom,
    String content,
  ) async {
    // TODO: support group chat
    final senderDeviceId = await DeviceInfoHelper().getDeviceId();
    if (senderDeviceId == null) {
      throw Exception('Sender Device Id is null');
    }

    DateTime sentAt = DateTime.now();

    switch (chatroom.type) {
      case ChatroomType.oneToOne:
        chatroom as OneToOneChat;
        await _sendMessage(
          senderDeviceId,
          chatroom.target.userId,
          me.userId, // chatroom id w.r.t. recipient, i.e. my user id
          content,
          sentAt,
        );
        break;
      case ChatroomType.group:
        chatroom as GroupChat;
        await Future.wait(chatroom.members.map((e) async => await _sendMessage(
              senderDeviceId,
              e.user.userId,
              chatroom.id,
              content,
              sentAt,
            )));
        break;
    }

    // save message to disk

    final plainMessage = PlainMessage(
      senderUserId: me.userId,
      chatroomId: chatroom.id,
      content: content,
      sentAt: sentAt,
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
      // add sender to contact
      await ContactStore().storeContact(sender);
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

    late final Uint8List decrypted;
    switch (message.cipherTextType) {
      case CiphertextMessage.prekeyType:
        final ciphertext = PreKeySignalMessage(message.content);
        decrypted = await remoteSessionCipher.decrypt(ciphertext);
        break;
      case CiphertextMessage.whisperType:
        final ciphertext = SignalMessage.fromSerialized(message.content);
        decrypted = await remoteSessionCipher.decryptFromSignal(ciphertext);
        break;
      default:
        return null;
    }
    final plaintext = utf8.decode(decrypted);

    final plainMessage = PlainMessage(
      senderUserId: sender.userId,
      chatroomId: message.chatroomId, // TODO: update to chatroom id
      content: plaintext,
      sentAt: message.sentAt,
    );

    // save message to disk
    final messageId = await MessageStore().storeMessage(plainMessage);
    plainMessage.id = messageId;

    // TODO: support group chat
    if (!(await ChatroomStore().contains(sender.userId))) {
      final chatroom = OneToOneChat(
        target: sender,
        unread: 1,
        latestMessage: plainMessage,
      );
      await ChatroomStore().save(chatroom);
    }
    final chatroom = await ChatroomStore().get(sender.userId);

    final receivedPlainMessage = ReceivedPlainMessage(
      sender: sender,
      chatroom: chatroom!,
      message: plainMessage,
    );
    return receivedPlainMessage;
  }
}
