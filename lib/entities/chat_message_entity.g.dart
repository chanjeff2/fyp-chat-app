// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageEntity _$ChatMessageEntityFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'senderUserId',
      'chatroomId',
      'content',
      'type',
      'sentAt',
      'isRead'
    ],
  );
  return ChatMessageEntity(
    id: json['id'] as int?,
    senderUserId: json['senderUserId'] as String,
    chatroomId: json['chatroomId'] as String,
    content: json['content'] as String,
    type: json['type'] as int,
    sentAt: json['sentAt'] as String,
    isRead: json['isRead'] as int,
  );
}

Map<String, dynamic> _$ChatMessageEntityToJson(ChatMessageEntity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['senderUserId'] = instance.senderUserId;
  val['chatroomId'] = instance.chatroomId;
  val['content'] = instance.content;
  val['type'] = instance.type;
  val['sentAt'] = instance.sentAt;
  val['isRead'] = instance.isRead;
  return val;
}
