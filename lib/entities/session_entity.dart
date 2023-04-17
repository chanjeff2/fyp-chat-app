import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

part 'session_entity.g.dart';

@JsonSerializable()
class SessionEntity {
  static const String createTableCommandFields = """
$columnDeviceId INTEGER NOT NULL, 
$columnUserId TEXT NOT NULL, 
$columnSession TEXT NOT NULL, 
PRIMARY KEY ($columnDeviceId, $columnUserId)
""";

  static const columnDeviceId = "deviceId";
  @JsonKey(required: true, name: columnDeviceId)
  final int deviceId;

  static const columnUserId = "userId";
  @JsonKey(required: true, name: columnUserId)
  final String userId;

  static const columnSession = "session";
  @JsonKey(required: true, name: columnSession)
  final String session;

  SessionEntity(this.deviceId, this.userId, this.session);

  Map<String, dynamic> toJson() => _$SessionEntityToJson(this);

  factory SessionEntity.fromJson(Map<String, dynamic> json) =>
      _$SessionEntityFromJson(json);

  SessionEntity.fromSessionRecord({
    required this.deviceId,
    required this.userId,
    required SessionRecord record,
  }) : session = record.encodeToString();

  SessionRecord toSessionRecord() {
    return SessionRecordExtension.decodeFromString(session);
  }
}
