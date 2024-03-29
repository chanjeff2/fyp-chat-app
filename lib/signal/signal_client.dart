import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fyp_chat_app/dto/media_key_item_dto.dart';
import 'package:fyp_chat_app/dto/update_keys_dto.dart';
import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:fyp_chat_app/models/account.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/enum.dart';
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
import 'package:fyp_chat_app/network/api.dart';
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
import 'package:pointycastle/export.dart';

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

  Future<void> updateKeysIfNeeded() async {
    final deviceId = await DeviceInfoHelper().getDeviceId();
    final dto = await KeysApi().checkIfNeedUpdateKeys(deviceId!);
    if (dto.signedPreKey) {
      await _generateAndStoreNewSignedPreKey();
    }
    if (dto.oneTimeKeys) {
      await _generateAndStoreNewOneTimeKeys();
    }
  }

  Future<void> _generateAndStoreNewSignedPreKey() async {
    // generate keys
    final identityKeyPair = await DiskIdentityKeyStore().getIdentityKeyPair();
    final nextSignedPreKeyId = await DiskSignedPreKeyStore().getTotalRows();
    final signedPreKey =
        generateSignedPreKey(identityKeyPair, nextSignedPreKeyId);

    final deviceId = await DeviceInfoHelper().getDeviceId();

    // store keys
    await DiskSignedPreKeyStore()
        .storeSignedPreKey(signedPreKey.id, signedPreKey);

    // upload keys to Server
    final dto = UpdateKeysDto(
      deviceId!,
      signedPreKey: SignedPreKey.fromSignedPreKeyRecord(signedPreKey).toDto(),
    );
    await KeysApi().updateKeys(dto);
  }

  Future<void> _generateAndStoreNewOneTimeKeys() async {
    final nextId = await DiskPreKeyStore().getTotalRows();
    // generate keys
    final oneTimeKeys = generatePreKeys(nextId, 110);

    final deviceId = await DeviceInfoHelper().getDeviceId();

    // store keys
    await Future.wait(
        oneTimeKeys.map((p) => DiskPreKeyStore().storePreKey(p.id, p)));

    // upload keys to Server
    final dto = UpdateKeysDto(
      deviceId!,
      oneTimeKeys:
          oneTimeKeys.map((e) => PreKey.fromPreKeyRecord(e).toDto()).toList(),
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

  Uint8List _generateRandomVector(int length) {
    Uint8List bytes = Uint8List(length);
    Random.secure()
        .nextInt(256); // Discard the first value to avoid modulo bias
    for (int i = 0; i < length; i++) {
      bytes[i] = Random.secure().nextInt(256);
    }
    return bytes;
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

    final devices = [1, ...deviceIds];
    // remove my device if send to self
    if (myUserId == recipientUserId) {
      devices.remove(senderDeviceId);
    }

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
      messageType: FCMEventType.textMessage,
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

    final devicesToRetry = [
      ...response.misMatchDeviceIds,
      ...response.missingDeviceIds
    ];
    // remove my device if send to self
    if (myUserId == recipientUserId) {
      devicesToRetry.remove(senderDeviceId);
    }

    // revoke session for updated and new devices
    final messagesRetry = await Future.wait(
      devicesToRetry.map((deviceId) async {
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
      messageType: FCMEventType.textMessage,
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
     * 1. Generate random IV, AES256
     * 2. Generate encryptor
     * 3. Encrypt message
     * 4. Send message and media key separately
     * */

    // 32 bytes = 256 bits, equivalent to common chat apps like WhatsApp
    Uint8List key = _generateRandomVector(32);
    Uint8List iv = _generateRandomVector(16);

    final CBCBlockCipher cbcCipher = CBCBlockCipher(AESEngine());
    final paddedCipher = PaddedBlockCipherImpl(PKCS7Padding(), cbcCipher);
    final ivParam = ParametersWithIV<KeyParameter>(KeyParameter(key), iv);
    final paddingParam = PaddedBlockCipherParameters(ivParam, null);
    paddedCipher.init(true, paddingParam);

    final encryptedData = paddedCipher.process(content);

    // Temporarily write file into cache and upload
    final cachePath = await getTemporaryDirectory();
    final path = "${cachePath.path}/$baseName";
    final file = File(path);

    await file.writeAsBytes(encryptedData);

    // Send media to server, and obtain the id for the key
    final mediaInfo = await MediaApi().uploadFile(file);

    final mediaKeyToSend = jsonEncode(MediaKeyItem(
            type: type,
            baseName: mediaInfo.name,
            aesKey: key,
            iv: iv,
            mediaId: mediaInfo.fileId)
        .toDto()
        .toJson());

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

    final devices = [1, ...deviceIds];
    // remove my device if send to self
    if (myUserId == recipientUserId) {
      devices.remove(senderDeviceId);
    }

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
      messageType: FCMEventType.mediaMessage,
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

    final devicesToRetry = [
      ...response.misMatchDeviceIds,
      ...response.missingDeviceIds
    ];
    // remove my device if send to self
    if (myUserId == recipientUserId) {
      devicesToRetry.remove(senderDeviceId);
    }

    // revoke session for updated and new devices
    final mediaKeyMsgRetry = await Future.wait(
      devicesToRetry.map((deviceId) async {
        final keyBundle =
            await KeysApi().getKeyBundle(recipientUserId, deviceId);
        await _establishSession(recipientUserId, keyBundle);

        return generateMessageToServer(
            recipientUserId, deviceId, mediaKeyToSend);
      }),
    );

    final mediaSendingRetry = SendMessageDao(
      senderDeviceId: senderDeviceId,
      recipientUserId: recipientUserId,
      chatroomId: chatroomId,
      messages: mediaKeyMsgRetry,
      messageType: FCMEventType.mediaMessage,
      sentAt: sentAt,
    ).toDto();

    await EventsApi().sendMessage(mediaSendingRetry);

    return mediaInfo.fileId;
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

    try {
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
          await Future.wait(
              chatroom.members.map((e) async => await _sendTextMessage(
                    me.userId,
                    senderDeviceId,
                    e.user.userId,
                    chatroom.id,
                    content,
                    sentAt.toUtc(),
                  )));
          break;
      }
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        rethrow;
      }
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

    late final Uint8List processedContent;

    switch (type) {
      case MessageType.image:
        processedContent = await FlutterImageCompress.compressWithList(
          mediaInBytes,
          quality: 75,
        );
        break;
      /*
      case MessageType.video:
        final mediaInfo = await VideoCompress.compressVideo(
          media.path,
          quality: VideoQuality.MediumQuality,
          deleteOrigin: false,
          includeAudio: true,
        );
        processedContent = mediaInfo!.file!.readAsBytesSync();
        break;
      */
      default:
        processedContent = Uint8List.fromList(mediaInBytes);
    }

    // Temporarily write file into cache and upload
    final cachePath = await getTemporaryDirectory();
    final tempPath = "${cachePath.path}/$baseName";
    final file = File(tempPath);

    await file.writeAsBytes(processedContent);

    // If size > 8MB, throw error
    const maximumSize = 8 * 1024 * 1024;
    if (file.lengthSync() > maximumSize) {
      throw Exception('Uploaded file exceeded 8MB. Your message is NOT sent.');
    }

    DateTime sentAt = DateTime.now();

    // The id for retrieving the media on server
    late final mediaId;

    try {
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
          final idList = await Future.wait(
              chatroom.members.map((e) async => await _sendMediaMessage(
                    me.userId,
                    senderDeviceId,
                    e.user.userId,
                    chatroom.id,
                    processedContent,
                    baseName,
                    type,
                    sentAt.toUtc(),
                  )));
          mediaId = idList.last;
          break;
      }
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        rethrow;
      }
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

  Future<ReceivedChatEvent?> processMessage(Message message) async {
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
      sentAt: message.sentAt.toLocal(),
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
          updatedAt: obtainedChatroom.updatedAt,
          groupType: obtainedChatroom.groupType,
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

    final receivedPlainMessage = ReceivedChatEvent(
      sender: sender,
      chatroom: chatroom!,
      event: plainMessage,
    );
    return receivedPlainMessage;
  }

  Future<ReceivedChatEvent?> processMediaMessage(Message message) async {
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

    final aesKey = recoveredKeyItem.aesKey;
    final iv = recoveredKeyItem.iv;

    final CBCBlockCipher cbcCipher = CBCBlockCipher(AESEngine());
    final paddedCipher = PaddedBlockCipherImpl(PKCS7Padding(), cbcCipher);
    final ivParam = ParametersWithIV<KeyParameter>(KeyParameter(aesKey), iv);
    final paddingParam = PaddedBlockCipherParameters(ivParam, null);
    paddedCipher.init(false, paddingParam);

    final media = await MediaApi().downloadFile(recoveredKeyItem.mediaId);

    /*
    final cachePath = await getTemporaryDirectory();
    final path = "${cachePath.path}/${recoveredKeyItem.baseName}";
    final file = File(path);

    await file.writeAsBytes(media);

    final formattedMedia = file.readAsBytesSync();
    */

    final decryptedMedia = paddedCipher.process(media);

    final reconstructedMediaItem = MediaItem(
        id: recoveredKeyItem.mediaId,
        content: decryptedMedia,
        type: recoveredKeyItem.type,
        baseName: recoveredKeyItem.baseName);

    final mediaMessage = MediaMessage(
      senderUserId: message.senderUserId,
      chatroomId: message.chatroomId,
      media: reconstructedMediaItem,
      type: recoveredKeyItem.type,
      sentAt: message.sentAt.toLocal(),
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
          groupType: obtainedChatroom.groupType,
          latestMessage: mediaMessage,
          createdAt: obtainedChatroom.createdAt,
          updatedAt: obtainedChatroom.updatedAt,
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

    final receivedPlainMessage = ReceivedChatEvent(
      sender: sender,
      chatroom: chatroom!,
      event: mediaMessage,
    );
    return receivedPlainMessage;
  }
}
