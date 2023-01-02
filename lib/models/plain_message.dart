import 'package:json_annotation/json_annotation.dart';

part 'plain_message.g.dart';

@JsonSerializable()
class PlainMessage {
  static const String createTableCommandFields =
      "$columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnSenderUserId TEXT, $columnRecipientUserId TEXT, $columnContent TEXT, $columnIsRead INTEGER";

  static const columnId = "id";
  @JsonKey(name: columnId, includeIfNull: false)
  int? id;

  static const columnSenderUserId = "senderUserId";
  @JsonKey(required: true, name: columnSenderUserId)
  final String senderUserId;

  static const columnRecipientUserId = "recipientUserId";
  @JsonKey(required: true, name: columnRecipientUserId)
  final String recipientUserId;

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

  static const columnIsRead = "isRead";
  @JsonKey(
    required: true,
    name: columnIsRead,
    fromJson: intToBool,
    toJson: boolToInt,
  )
  final bool isRead;

  PlainMessage({
    this.id,
    required this.senderUserId,
    required this.recipientUserId,
    required this.content,
    required this.sentAt,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => _$PlainMessageToJson(this);

  factory PlainMessage.fromJson(Map<String, dynamic> json) =>
      _$PlainMessageFromJson(json);
}

String toIso8601String(DateTime dateTime) {
  return dateTime.toIso8601String();
}

bool intToBool(int i) {
  return i == 1;
}

int boolToInt(bool isTrue) {
  return isTrue ? 1 : 0;
}
