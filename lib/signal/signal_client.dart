import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fyp_chat_app/dto/account_dto.dart';
import 'package:fyp_chat_app/dto/media_key_item_dto.dart';
import 'package:fyp_chat_app/dto/update_keys_dto.dart';
import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:fyp_chat_app/models/account.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/key_bundle.dart';
import 'package:fyp_chat_app/models/media_item.dart';
import 'package:fyp_chat_app/models/media_key_item.dart';
import 'package:fyp_chat_app/models/message.dart';
import 'package:fyp_chat_app/models/message_to_server.dart';
import 'package:fyp_chat_app/models/one_to_one_chat.dart';
import 'package:fyp_chat_app/models/chat_message.dart';
import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/models/media_message.dart';
import 'package:fyp_chat_app/models/pre_key.dart';
import 'package:fyp_chat_app/models/received_plain_message.dart';
import 'package:fyp_chat_app/models/signed_pre_key.dart';
import 'package:fyp_chat_app/models/user.dart';
import 'package:fyp_chat_app/network/devices_api.dart';
import 'package:fyp_chat_app/network/events_api.dart';
import 'package:fyp_chat_app/network/group_chat_api.dart';
import 'package:fyp_chat_app/network/keys_api.dart';
import 'package:fyp_chat_app/network/media_api.dart';
import 'package:fyp_chat_app/network/users_api.dart';
import 'package:fyp_chat_app/signal/device_helper.dart';
import 'package:fyp_chat_app/storage/account_store.dart';
import 'package:fyp_chat_app/storage/chatroom_store.dart';
import 'package:fyp_chat_app/storage/contact_store.dart';
import 'package:fyp_chat_app/storage/disk_identity_key_store.dart';
import 'package:fyp_chat_app/storage/disk_pre_key_store.dart';
import 'package:fyp_chat_app/storage/disk_session_store.dart';
import 'package:fyp_chat_app/storage/disk_signed_pre_key_store.dart';
import 'package:fyp_chat_app/storage/media_store.dart';
import 'package:fyp_chat_app/storage/message_store.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:fyp_chat_app/models/send_message_dao.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';

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

    late final int? deviceId;

    // store keys
    await Future.wait([
      DiskIdentityKeyStore().storeIdentityKeyPair(identityKeyPair),
      Future.wait(
          oneTimeKeys.map((p) => DiskPreKeyStore().storePreKey(p.id, p))),
      DiskSignedPreKeyStore().storeSignedPreKey(signedPreKey.id, signedPreKey),
      DeviceInfoHelper().getDeviceId().then((id) {
        deviceId = id;
      }),
    ]);

    // upload keys to Server
    final dto = UpdateKeysDto(
      deviceId!,
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

  Future<void> _sendTextMessage(
    String myUserId, // to avoid send to sender device
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
      final keyBundle = await KeysApi().getAllKeyBundle(recipientUserId);

      await _establishSession(recipientUserId, keyBundle);
    }

    final deviceIds =
        await DiskSessionStore().getSubDeviceSessions(recipientUserId);

    // remove my device if send to self
    final devices = (myUserId == recipientUserId)
        ? ([1, ...deviceIds]).where((id) => id != senderDeviceId)
        : ([1, ...deviceIds]);

    final messages = await Future.wait(
      devices.map((deviceId) async =>
          generateMessageToServer(recipientUserId, deviceId, content)),
    );

    // send message use EventsApi()
    final message = SendMessageDao(
      senderDeviceId: senderDeviceId,
      recipientUserId: recipientUserId,
      chatroomId: chatroomId,
      messages: messages,
      messageType: MessageType.text,
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
        final keyBundle =
            await KeysApi().getKeyBundle(recipientUserId, deviceId);
        await _establishSession(recipientUserId, keyBundle);

        return generateMessageToServer(recipientUserId, deviceId, content);
      }),
    );

    final messageRetry = SendMessageDao(
      senderDeviceId: senderDeviceId,
      recipientUserId: recipientUserId,
      chatroomId: chatroomId,
      messages: messagesRetry,
      messageType: MessageType.text,
      sentAt: sentAt,
    ).toDto();

    await EventsApi().sendMessage(messageRetry);
  }

  Future<String> _sendMediaMessage(
    String myUserId, // to avoid send to sender device
    int senderDeviceId,
    String recipientUserId,
    String chatroomId,
    Uint8List content,
    String baseName,
    MessageType type,
    DateTime sentAt,
  ) async {
    /**
     * Encryption of file:
     * 1. Generate random IV, AES256 and encryptor
     * 2. Generate encryptor
     * 3. Encrypt message
     * 4. Send message and media key separately
     * */ 
    
    // 32 bytes = 256 bits, equivalent to common chat apps like WhatsApp
    Key key = Key.fromSecureRandom(32); 
    IV iv = IV.fromSecureRandom(32);

    Encrypter encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encryptedData = encrypter.encryptBytes(content, iv: iv).bytes;

    // Temporarily write file into cache and upload
    final cachePath = await getTemporaryDirectory();
    final path = "$cachePath/$baseName";
    final file = File(path);

    await file.writeAsBytes(encryptedData);

    // Send media to server, and obtain the id for the key
    final mediaInfo = await MediaApi().uploadFile(file);

    final mediaKeyToSend = MediaKeyItem(
      type: type,
      baseName: mediaInfo.name,
      aesKey: key.bytes,
      iv: iv.bytes,
      mediaId: mediaInfo.id
    ).toDto().toJson().toString();

    // check if already establish session
    final remotePrimaryAddress = SignalProtocolAddress(
      recipientUserId,
      1, // device#1 is primary device
    );

    final containsSession =
        await DiskSessionStore().containsSession(remotePrimaryAddress);

    if (!containsSession) {
      final keyBundle = await KeysApi().getAllKeyBundle(recipientUserId);

      await _establishSession(recipientUserId, keyBundle);
    }

    final deviceIds =
        await DiskSessionStore().getSubDeviceSessions(recipientUserId);

    // remove my device if send to self
    final devices = (myUserId == recipientUserId)
        ? ([1, ...deviceIds]).where((id) => id != senderDeviceId)
        : ([1, ...deviceIds]);

    final mediaKeyMsg = await Future.wait(
      devices.map((deviceId) async =>
          generateMessageToServer(recipientUserId, deviceId, mediaKeyToSend)),
    );

    // send media key message use EventsApi()
    final fileMessageSending = SendMessageDao(
      senderDeviceId: senderDeviceId,
      recipientUserId: recipientUserId,
      chatroomId: chatroomId,
      messages: mediaKeyMsg,
      messageType: MessageType.mediaKey,
      sentAt: sentAt,
    ).toDto();

    // send media key message use EventsApi()
    /*
    final mediaKeySending = SendMessageDao(
      senderDeviceId: senderDeviceId,
      recipientUserId: recipientUserId,
      chatroomId: chatroomId,
      messages: mediaKeyMessage,
      type: 2,
      sentAt: sentAt,
    ).toDto();
    */

    final response = await EventsApi().sendMessage(fileMessageSending);

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
    final mediaKeyMsgRetry = await Future.wait(
      [...response.misMatchDeviceIds, ...response.missingDeviceIds]
          .map((deviceId) async {
        final keyBundle =
            await KeysApi().getKeyBundle(recipientUserId, deviceId);
        await _establishSession(recipientUserId, keyBundle);

        return generateMessageToServer(recipientUserId, deviceId, mediaKeyToSend);
      }),
    );

    final mediaSendingRetry = SendMessageDao(
      senderDeviceId: senderDeviceId,
      recipientUserId: recipientUserId,
      chatroomId: chatroomId,
      messages: mediaKeyMsgRetry,
      messageType: MessageType.mediaKey,
      sentAt: sentAt,
    ).toDto();

    await EventsApi().sendMessage(mediaSendingRetry);

    return mediaInfo.id;
  }

  Future<PlainMessage> sendMessageToChatroom(
    Account me, // pass me to speed up process
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
        await _sendTextMessage(
          me.userId,
          senderDeviceId,
          chatroom.target.userId,
          me.userId, // chatroom id w.r.t. recipient, i.e. my user id
          content,
          sentAt.toUtc(),
        );
        break;
      case ChatroomType.group:
        chatroom as GroupChat;
        await Future.wait(chatroom.members.map((e) async => await _sendTextMessage(
              me.userId,
              senderDeviceId,
              e.user.userId,
              chatroom.id,
              content,
              sentAt.toUtc(),
            )));
        break;
    }

    // save message to disk

    final plainMessage = PlainMessage(
      senderUserId: me.userId,
      chatroomId: chatroom.id,
      content: content,
      sentAt: sentAt,
      isRead: true,
    );

    final messageId = await MessageStore().storeMessage(plainMessage);
    plainMessage.id = messageId;

    return plainMessage;
  }

  Future<MediaMessage> sendMediaToChatroom(
    Account me,
    Chatroom chatroom,
    File media,
    String? mediaPath,
    MessageType type,
  ) async {
    // TODO: support group chat
    final senderDeviceId = await DeviceInfoHelper().getDeviceId();
    if (senderDeviceId == null) {
      throw Exception('Sender Device Id is null');
    }
    
    final path = mediaPath ?? media.path;
    final baseName = p.basename(path);

    // Process to the media. Particularly, compression
    // Currently support only video and image
    final mediaInBytes = File(path).readAsBytesSync();

    final content = mediaInBytes;
    late final processedContent;

    switch (type) {
      case MessageType.image:
        processedContent = await FlutterImageCompress.compressWithList(
          content,
          quality: 5,
        );
        break;
      case MessageType.video:
        final mediaInfo = await VideoCompress.compressVideo(
          media.path,
          quality: VideoQuality.MediumQuality,
          deleteOrigin: false,
          includeAudio: true,
        );
        processedContent = mediaInfo!.file!.readAsBytesSync();
        break;
      default:
        processedContent = content;
    }

    // If size > 8MB, throw error
    const maximumSize = 8 * 1024 * 1024;
    if (File.fromRawPath(processedContent).lengthSync() > maximumSize) {
      throw Exception('Uploaded file exceeded 8MB. Your message is NOT sent.');
    }

    DateTime sentAt = DateTime.now();

    // The id for retrieving the media on server
    late final mediaId;

    switch (chatroom.type) {
      case ChatroomType.oneToOne:
        chatroom as OneToOneChat;
        mediaId = await _sendMediaMessage(
          me.userId,
          senderDeviceId,
          chatroom.target.userId,
          me.userId, // chatroom id w.r.t. recipient, i.e. my user id
          processedContent,
          baseName,
          type,
          sentAt.toUtc(),
        );
        break;
      case ChatroomType.group:
        chatroom as GroupChat;
        mediaId = await Future.wait(chatroom.members.map((e) async => await _sendMediaMessage(
              me.userId,
              senderDeviceId,
              e.user.userId,
              chatroom.id,
              processedContent,
              baseName,
              type,
              sentAt.toUtc(),
            )));
        break;
    }

    // Generated media (For group message, save with the id of the last member send to)
    final mediaGenerated = MediaItem(
      id: mediaId,
      content: processedContent,
      type: type,
      baseName: baseName,
    );

    // save message to disk
    final mediaMessage = MediaMessage(
      senderUserId: me.userId,
      chatroomId: chatroom.id,
      media: mediaGenerated,
      type: type,
      sentAt: sentAt,
      isRead: true,
    );

    final messageId = await MessageStore().storeMessage(mediaMessage);
    await MediaStore().storeMedia(mediaGenerated);
    mediaMessage.id = messageId;

    return mediaMessage;
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
      sender = await UsersApi().getUserById(message.senderUserId);
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
    /*
    if (!(await ChatroomStore().contains(sender.userId))) {
      final chatroom = OneToOneChat(
        target: sender,
        unread: 1,
        latestMessage: plainMessage,
        createdAt: DateTime.now(),
      );
      await ChatroomStore().save(chatroom);
    }
    final chatroom = await ChatroomStore().get(sender.userId);
    */
    if (!(await ChatroomStore().contains(message.chatroomId))) {
      // In theory, if the chatroom is group chat, sender ID != chatroom ID (chance -> 0)
      if (sender.userId != message.chatroomId) {
        // If possible, develop another way to get group chat without re-instantiate a new GroupChat
        final obtainedChatroom =
            await GroupChatApi().getGroup(message.chatroomId);
        final groupChatroom = GroupChat(
          id: obtainedChatroom.id,
          members: obtainedChatroom.members,
          name: obtainedChatroom.name,
          unread: 1,
          latestMessage: plainMessage,
          createdAt: obtainedChatroom.createdAt,
        );
        await ChatroomStore().save(groupChatroom);
      } else {
        final oneToOneChatroom = OneToOneChat(
          target: sender,
          latestMessage: plainMessage,
          unread: 1,
          createdAt: DateTime.now(),
        );
        await ChatroomStore().save(oneToOneChatroom);
      }
    }
    final chatroom = await ChatroomStore().get(message.chatroomId);

    final receivedPlainMessage = ReceivedPlainMessage(
      sender: sender,
      chatroom: chatroom!,
      message: plainMessage,
    );
    return receivedPlainMessage;
  }

  Future<ReceivedPlainMessage?> processMediaMessage(Message message) async {
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
      sender = await UsersApi().getUserById(message.senderUserId);
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

    // Part where diverts from normal process message - Construct the item and obtain keys
    final recoveredDto = MediaKeyItemDto.fromJson(jsonDecode(plaintext));
    final recoveredKeyItem = MediaKeyItem.fromDto(recoveredDto);

    final aesKey = Key(recoveredKeyItem.aesKey);
    final iv = IV(recoveredKeyItem.iv);

    final encrypter =  Encrypter(AES(aesKey));

    final media = await MediaApi().downloadFile(recoveredKeyItem.mediaId);
    
    final decryptedMedia = Uint8List.fromList(encrypter.decryptBytes(Encrypted(media), iv: iv));

    final reconstructedMediaItem = MediaItem(
      id: recoveredKeyItem.mediaId,
      content: decryptedMedia,
      type: recoveredKeyItem.type,
      baseName: recoveredKeyItem.baseName
    );

    final mediaMessage = MediaMessage(
      senderUserId: message.senderUserId,
      chatroomId: message.chatroomId,
      media: reconstructedMediaItem,
      type: recoveredKeyItem.type,
      sentAt: message.sentAt,
    );

    // save message and media to disk
    final messageId = await MessageStore().storeMessage(mediaMessage);
    await MediaStore().storeMedia(reconstructedMediaItem);
    mediaMessage.id = messageId;

    if (!(await ChatroomStore().contains(message.chatroomId))) {
      // In theory, if the chatroom is group chat, sender ID != chatroom ID (chance -> 0)
      if (sender.userId != message.chatroomId) {
        final obtainedChatroom =
            await GroupChatApi().getGroup(message.chatroomId);
        final groupChatroom = GroupChat(
          id: obtainedChatroom.id,
          members: obtainedChatroom.members,
          name: obtainedChatroom.name,
          unread: 1,
          latestMessage: mediaMessage,
          createdAt: obtainedChatroom.createdAt,
        );
        await ChatroomStore().save(groupChatroom);
      } else {
        final oneToOneChatroom = OneToOneChat(
          target: sender,
          latestMessage: mediaMessage,
          unread: 1,
          createdAt: DateTime.now(),
        );
        await ChatroomStore().save(oneToOneChatroom);
      }
    }
    final chatroom = await ChatroomStore().get(message.chatroomId);
    
    final receivedPlainMessage = ReceivedPlainMessage(
      sender: sender,
      chatroom: chatroom!,
      message: mediaMessage,
    );
    return receivedPlainMessage;
  }
}
