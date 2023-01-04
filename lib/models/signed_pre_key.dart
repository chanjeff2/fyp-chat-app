import 'package:flutter/foundation.dart';
import 'package:fyp_chat_app/dto/signed_pre_key_dto.dart';
import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:fyp_chat_app/models/pre_key.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class SignedPreKey extends PreKey {
  final Uint8List signature;
  SignedPreKey(int id, ECPublicKey key, this.signature) : super(id, key);

  SignedPreKey.fromDto(SignedPreKeyDto dto)
      : signature = SignatureExtension.decodeFromString(dto.signature),
        super.fromDto(dto);

  SignedPreKey.fromSignedPreKeyRecord(SignedPreKeyRecord record)
      : signature = record.signature,
        super.fromSignedPreKeyRecord(record);

  @override
  SignedPreKeyDto toDto() {
    return SignedPreKeyDto(
      id,
      key.encodeToString(),
      signature.encodeToString(),
    );
  }
}
