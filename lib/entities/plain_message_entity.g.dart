// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plain_message_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlainMessageEntity _$PlainMessageEntityFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'senderUserId',
      'chatroomId',
      'content',
      'sentAt',
      'isRead'
    ],
  );
  return PlainMessageEntity(
    id: json['id'] as int?,
    senderUserId: json['senderUserId'] as String,
    chatroomId: json['chatroomId'] as String,
    content: json['content'] as String,
    sentAt: json['sentAt'] as String,
    isRead: json['isRead'] as int,
  );
}

Map<String, dynamic> _$PlainMessageEntityToJson(PlainMessageEntity instance) {
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
  val['sentAt'] = instance.sentAt;
  val['isRead'] = instance.isRead;
  return val;
}
