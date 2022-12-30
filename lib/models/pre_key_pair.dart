import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

part 'pre_key_pair.g.dart';

@JsonSerializable()
class PreKeyPair {
  static const String createTableCommandFields =
      "$columnId INTEGER PRIMARY KEY, $columnKeyPair TEXT";

  static const columnId = "id";
  @JsonKey(required: true, name: columnId)
  final int id;

  static const columnKeyPair = "keyPair";
  @JsonKey(required: true, name: columnKeyPair)
  final String keyPair;

  PreKeyPair(this.id, this.keyPair);

  Map<String, dynamic> toJson() => _$PreKeyPairToJson(this);

  factory PreKeyPair.fromJson(Map<String, dynamic> json) =>
      _$PreKeyPairFromJson(json);

  PreKeyPair.fromPreKeyRecord(PreKeyRecord record)
      : id = record.id,
        keyPair = base64.encode(record.serialize());

  PreKeyRecord toPreKeyRecord() {
    return PreKeyRecord.fromBuffer(base64.decode(keyPair));
  }
}
