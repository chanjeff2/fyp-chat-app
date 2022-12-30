import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

part 'their_identity_key.g.dart';

@JsonSerializable()
class TheirIdentityKey {
  static const String createTableCommandFields =
      "$columnDeviceId INTEGER, $columnName TEXT, $columnKey, PRIMARY KEY ($columnDeviceId, $columnName)";

  static const columnDeviceId = "deviceId";
  @JsonKey(required: true, name: columnDeviceId)
  final int deviceId;

  static const columnName = "name";
  @JsonKey(required: true, name: columnName)
  final String name;

  static const columnKey = "key";
  @JsonKey(required: true, name: columnKey)
  final String key;

  TheirIdentityKey(this.deviceId, this.name, this.key);

  Map<String, dynamic> toJson() => _$TheirIdentityKeyToJson(this);

  factory TheirIdentityKey.fromJson(Map<String, dynamic> json) =>
      _$TheirIdentityKeyFromJson(json);

  TheirIdentityKey.fromIdentityKey({
    required this.deviceId,
    required this.name,
    required IdentityKey key,
  }) : key = base64.encode(key.serialize());

  IdentityKey toIdentityKey() {
    return IdentityKey.fromBytes(base64.decode(key), 0);
  }
}
