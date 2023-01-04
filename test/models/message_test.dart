import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/message_dto.dart';
import 'package:fyp_chat_app/dto/send_message_dto.dart';
import 'package:fyp_chat_app/models/message.dart';
import 'package:fyp_chat_app/models/send_message_dao.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

void main() {
  late final IdentityKeyPair identityKeyPair;
  late final int registrationId;
  late final List<PreKeyRecord> preKeys;
  late final SignedPreKeyRecord signedPreKey;
  const deviceId = 1;

  late final IdentityKeyPair remoteIdentityKeyPair;
  late final int remoteRegistrationId;
  late final List<PreKeyRecord> remotePreKeys;
  late final SignedPreKeyRecord remoteSignedPreKey;
  const remoteDeviceId = 1;

  late final InMemorySignalProtocolStore store;
  late final InMemorySignalProtocolStore remoteStore;
  setUpAll(() async {
    identityKeyPair = generateIdentityKeyPair();
    registrationId = generateRegistrationId(false);
    preKeys = generatePreKeys(0, 10);
    signedPreKey = generateSignedPreKey(identityKeyPair, 0);

    store = InMemorySignalProtocolStore(identityKeyPair, registrationId);
    for (final p in preKeys) {
      await store.storePreKey(p.id, p);
    }
    await store.storeSignedPreKey(signedPreKey.id, signedPreKey);

    remoteIdentityKeyPair = generateIdentityKeyPair();
    remoteRegistrationId = generateRegistrationId(false);
    remotePreKeys = generatePreKeys(0, 10);
    remoteSignedPreKey = generateSignedPreKey(remoteIdentityKeyPair, 0);

    remoteStore = InMemorySignalProtocolStore(
        remoteIdentityKeyPair, remoteRegistrationId);
    for (final p in remotePreKeys) {
      await remoteStore.storePreKey(p.id, p);
    }
    await remoteStore.storeSignedPreKey(
        remoteSignedPreKey.id, remoteSignedPreKey);
  });
  test('serialize and de-serialize', () async {
    // sender side
    const remoteAddress = SignalProtocolAddress('receiver', remoteDeviceId);
    final sessionBuilder = SessionBuilder.fromSignalStore(store, remoteAddress);
    final remoteKeys = PreKeyBundle(
      remoteRegistrationId,
      remoteDeviceId,
      remotePreKeys[0].id,
      remotePreKeys[0].getKeyPair().publicKey,
      remoteSignedPreKey.id,
      remoteSignedPreKey.getKeyPair().publicKey,
      remoteSignedPreKey.signature,
      remoteIdentityKeyPair.getPublicKey(),
    );
    await sessionBuilder.processPreKeyBundle(remoteKeys);

    final sessionCipher = SessionCipher.fromStore(store, remoteAddress);
    const plaintext = 'hello';
    final ciphertext =
        await sessionCipher.encrypt(Uint8List.fromList(utf8.encode(plaintext)));

    // serialize
    final sentAt = DateTime.now();
    final serialized = SendMessageDao(
      deviceId,
      'recipientUserId',
      remoteDeviceId,
      ciphertext as PreKeySignalMessage,
      sentAt,
    ).toDto();
    final messageDto = receiveMessage(serialized);
    final message = Message.fromDto(messageDto);

    // check if message content equal
    expect(
        listEquals(message.content.serialize(), ciphertext.serialize()), true);

    // receiver side
    const localAddress = SignalProtocolAddress('sender', deviceId);
    final remoteSessionCipher =
        SessionCipher.fromStore(remoteStore, localAddress);
    final decrypted = await remoteSessionCipher.decrypt(ciphertext);
    final receivedPlaintext = utf8.decode(decrypted);
    expect(receivedPlaintext, plaintext);
  });
}

MessageDto receiveMessage(SendMessageDto dto) {
  return MessageDto(
    'senderUserId',
    dto.senderDeviceId.toString(),
    dto.content,
    dto.sentAt,
  );
}
