import 'package:json_annotation/json_annotation.dart';

part 'chat_message_entity.g.dart';

@JsonSerializable()
class ChatMessageEntity {
  static const String createTableCommandFields = """
$columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
$columnSenderUserId TEXT NOT NULL, 
$columnChatroomId TEXT NOT NULL, 
$columnContent TEXT NOT NULL, 
$columnType INTEGER NOT NULL,
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

  static const columnType = "type";

  // 0: text, 1: image, 2: video, 3: audio, 4: document, 5: mediaKey, 6: system log
  @JsonKey(required: true, name: columnType)
  final int type;

  static const columnSentAt = "sentAt";
  @JsonKey(required: true, name: columnSentAt)
  final String sentAt;

  static const columnIsRead = "isRead";

  // 0: false, 1: true
  @JsonKey(required: true, name: columnIsRead)
  final int isRead;

  ChatMessageEntity({
    this.id,
    required this.senderUserId,
    required this.chatroomId,
    required this.content,
    required this.type,
    required this.sentAt,
    required this.isRead,
  });

  Map<String, dynamic> toJson() => _$ChatMessageEntityToJson(this);

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageEntityFromJson(json);
}
