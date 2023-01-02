import 'package:json_annotation/json_annotation.dart';

part 'plain_message.g.dart';

@JsonSerializable()
class PlainMessage {
  static const String createTableCommandFields =
      "$columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnSenderUserId TEXT, $columnSenderUsername TEXT, $columnContent TEXT";

  static const columnId = "id";
  @JsonKey(name: columnId, includeIfNull: false)
  int? id;

  static const columnSenderUserId = "senderUserId";
  @JsonKey(required: true, name: columnSenderUserId)
  final String senderUserId;

  static const columnSenderUsername = "senderUsername";
  @JsonKey(required: true, name: columnSenderUsername)
  final String senderUsername;

  static const columnContent = "content";
  @JsonKey(required: true, name: columnContent)
  final String content;

  static const columnSentAt = "sentAt";
  @JsonKey(
    required: true,
    name: columnSentAt,
    fromJson: DateTime.parse,
    toJson: toIso8601String,
  )
  final DateTime sentAt;

  PlainMessage({
    this.id,
    required this.senderUserId,
    required this.senderUsername,
    required this.content,
    required this.sentAt,
  });

  Map<String, dynamic> toJson() => _$PlainMessageToJson(this);

  factory PlainMessage.fromJson(Map<String, dynamic> json) =>
      _$PlainMessageFromJson(json);
}

String toIso8601String(DateTime dateTime) {
  return dateTime.toIso8601String();
}
