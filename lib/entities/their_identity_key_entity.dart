import 'dart:convert';

import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

part 'their_identity_key_entity.g.dart';

@JsonSerializable()
class TheirIdentityKeyEntity {
  static const String createTableCommandFields = """
$columnDeviceId INTEGER NOT NULL, 
$columnUserId TEXT NOT NULL, 
$columnKey TEXT NOT NULL, 
PRIMARY KEY ($columnDeviceId, $columnUserId)
""";

  static const columnDeviceId = "deviceId";
  @JsonKey(required: true, name: columnDeviceId)
  final int deviceId;

  static const columnUserId = "userId";
  @JsonKey(required: true, name: columnUserId)
  final String userId;

  static const columnKey = "key";
  @JsonKey(required: true, name: columnKey)
  final String key;

  TheirIdentityKeyEntity(this.deviceId, this.userId, this.key);

  Map<String, dynamic> toJson() => _$TheirIdentityKeyEntityToJson(this);

  factory TheirIdentityKeyEntity.fromJson(Map<String, dynamic> json) =>
      _$TheirIdentityKeyEntityFromJson(json);

  TheirIdentityKeyEntity.fromIdentityKey({
    required this.deviceId,
    required this.userId,
    required IdentityKey key,
  }) : key = key.encodeToString();

  IdentityKey toIdentityKey() {
    return IdentityKeyExtension.decodeFromString(key);
  }
}
