import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

part 'signed_pre_key_pair.g.dart';

@JsonSerializable()
class SignedPreKeyPair {
  static const String createTableCommandFields =
      "$columnId INTEGER PRIMARY KEY, $columnKeyPair TEXT";

  static const columnId = "id";
  @JsonKey(required: true, name: columnId)
  final int id;

  static const columnKeyPair = "keyPair";
  @JsonKey(required: true, name: columnKeyPair)
  final String keyPair;

  SignedPreKeyPair(this.id, this.keyPair);

  Map<String, dynamic> toJson() => _$SignedPreKeyPairToJson(this);

  factory SignedPreKeyPair.fromJson(Map<String, dynamic> json) =>
      _$SignedPreKeyPairFromJson(json);

  SignedPreKeyPair.fromSignedPreKeyRecord(SignedPreKeyRecord record)
      : id = record.id,
        keyPair = base64.encode(record.serialize());

  SignedPreKeyRecord toSignedPreKeyRecord() {
    return SignedPreKeyRecord.fromSerialized(base64.decode(keyPair));
  }
}