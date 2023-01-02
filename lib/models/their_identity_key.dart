import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

part 'their_identity_key.g.dart';

@JsonSerializable()
class TheirIdentityKey {
  static const String createTableCommandFields =
      "$columnDeviceId INTEGER, $columnUserId TEXT, $columnKey, PRIMARY KEY ($columnDeviceId, $columnUserId), UNIQUE ($columnDeviceId, $columnUserId)";

  static const columnDeviceId = "deviceId";
  @JsonKey(required: true, name: columnDeviceId)
  final int deviceId;

  static const columnUserId = "userId";
  @JsonKey(required: true, name: columnUserId)
  final String userId;

  static const columnKey = "key";
  @JsonKey(required: true, name: columnKey)
  final String key;

  TheirIdentityKey(this.deviceId, this.userId, this.key);

  Map<String, dynamic> toJson() => _$TheirIdentityKeyToJson(this);

  factory TheirIdentityKey.fromJson(Map<String, dynamic> json) =>
      _$TheirIdentityKeyFromJson(json);

  TheirIdentityKey.fromIdentityKey({
    required this.deviceId,
    required this.userId,
    required IdentityKey key,
  }) : key = base64.encode(key.serialize());

  IdentityKey toIdentityKey() {
    return IdentityKey.fromBytes(base64.decode(key), 0);
  }
}
