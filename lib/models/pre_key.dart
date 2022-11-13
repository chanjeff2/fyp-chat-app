import 'dart:convert';

import 'package:fyp_chat_app/dto/pre_key_dto.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class PreKey {
  int id;
  ECPublicKey key;

  PreKey(this.id, this.key);

  PreKey.fromDto(PreKeyDto dto)
      : id = dto.id,
        key = DjbECPublicKey(base64.decode(dto.key));

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
