import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fyp_chat_app/models/pre_key_dto.dart';
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

class SignedPreKey extends PreKey {
  Uint8List signature;
  SignedPreKey(int id, ECPublicKey key, this.signature) : super(id, key);

  SignedPreKey.fromDto(SignedPreKeyDto dto)
      : signature = base64.decode(dto.signature),
        super.fromDto(dto);

  SignedPreKey.fromSignedPreKeyRecord(SignedPreKeyRecord record)
      : signature = record.signature,
        super.fromSignedPreKeyRecord(record);

  SignedPreKeyDto toDto() {
    return SignedPreKeyDto(
      id,
      base64.encode(key.serialize()),
      base64.encode(signature),
    );
  }
}
