import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

part 'session.g.dart';

@JsonSerializable()
class Session {
  static const String createTableCommandFields =
      "$columnDeviceId INTEGER, $columnUserId TEXT, $columnSession TEXT, PRIMARY KEY ($columnDeviceId, $columnUserId), UNIQUE ($columnDeviceId, $columnUserId)";

  static const columnDeviceId = "deviceId";
  @JsonKey(required: true, name: columnDeviceId)
  final int deviceId;

  static const columnUserId = "userId";
  @JsonKey(required: true, name: columnUserId)
  final String userId;

  static const columnSession = "session";
  @JsonKey(required: true, name: columnSession)
  final String session;

  Session(this.deviceId, this.userId, this.session);

  Map<String, dynamic> toJson() => _$SessionToJson(this);

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Session.fromSessionRecord({
    required this.deviceId,
    required this.userId,
    required SessionRecord record,
  }) : session = base64.encode(record.serialize());

  SessionRecord toSessionRecord() {
    return SessionRecord.fromSerialized(base64.decode(session));
  }
}
