import 'dart:convert';

import 'package:fyp_chat_app/dto/pre_key_dto.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class PreKey {
  final int id;
  final ECPublicKey key;

  PreKey(this.id, this.key);

  PreKey.fromDto(PreKeyDto dto)
      : id = dto.id,
        key = Curve.decodePoint(base64.decode(dto.key), 0);

  PreKey.fromPreKeyRecord(PreKeyRecord record)
      : id = record.id,
        key = record.getKeyPair().publicKey;

  PreKey.fromSignedPreKeyRecord(SignedPreKeyRecord record)
      : id = record.id,
        key = record.getKeyPair().publicKey;

  PreKeyDto toDto() {
    return PreKeyDto(
      id,
      base64.encode(key.serialize()),
    );
  }
}
