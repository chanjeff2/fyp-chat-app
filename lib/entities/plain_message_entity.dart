import 'package:json_annotation/json_annotation.dart';

part 'plain_message_entity.g.dart';

@JsonSerializable()
class PlainMessageEntity {
  static const String createTableCommandFields = """
$columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
$columnSenderUserId TEXT NOT NULL, 
$columnChatroomId TEXT NOT NULL, 
$columnContent TEXT NOT NULL, 
$columnSentAt TEXT NOT NULL, 
$columnIsRead INTEGER NOT NULL
""";

  static const columnId = "id";
  @JsonKey(name: columnId, includeIfNull: false)
  int? id;

  static const columnSenderUserId = "senderUserId";
  @JsonKey(required: true, name: columnSenderUserId)
  final String senderUserId;

  static const columnChatroomId = "chatroomId";
  @JsonKey(required: true, name: columnChatroomId)
  final String chatroomId;

  static const columnContent = "content";
  @JsonKey(required: true, name: columnContent)
  final String content;

  static const columnSentAt = "sentAt";
  @JsonKey(required: true, name: columnSentAt)
  final String sentAt;

  static const columnIsRead = "isRead";

  /// 0: false, 1: true
  @JsonKey(required: true, name: columnIsRead)
  final int isRead;

  PlainMessageEntity({
    this.id,
    required this.senderUserId,
    required this.chatroomId,
    required this.content,
    required this.sentAt,
    required this.isRead,
  });

  Map<String, dynamic> toJson() => _$PlainMessageEntityToJson(this);

  factory PlainMessageEntity.fromJson(Map<String, dynamic> json) =>
      _$PlainMessageEntityFromJson(json);
}
