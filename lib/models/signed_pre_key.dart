import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fyp_chat_app/dto/signed_pre_key_dto.dart';
import 'package:fyp_chat_app/models/pre_key.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class SignedPreKey extends PreKey {
  Uint8List signature;
  SignedPreKey(int id, ECPublicKey key, this.signature) : super(id, key);

  SignedPreKey.fromDto(SignedPreKeyDto dto)
      : signature = base64.decode(dto.signature),
        super.fromDto(dto);

  SignedPreKey.fromSignedPreKeyRecord(SignedPreKeyRecord record)
      : signature = record.signature,
        super.fromSignedPreKeyRecord(record);

  @override
  SignedPreKeyDto toDto() {
    return SignedPreKeyDto(
      id,
      base64.encode(key.serialize()),
      base64.encode(signature),
    );
  }
}
