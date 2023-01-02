// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plain_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlainMessage _$PlainMessageFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'senderUserId',
      'senderUsername',
      'content',
      'sentAt',
      'isRead'
    ],
  );
  return PlainMessage(
    id: json['id'] as int?,
    senderUserId: json['senderUserId'] as String,
    senderUsername: json['senderUsername'] as String,
    content: json['content'] as String,
    sentAt: DateTime.parse(json['sentAt'] as String),
    isRead: json['isRead'] == null ? false : intToBool(json['isRead'] as int),
  );
}

Map<String, dynamic> _$PlainMessageToJson(PlainMessage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['senderUserId'] = instance.senderUserId;
  val['senderUsername'] = instance.senderUsername;
  val['content'] = instance.content;
  val['sentAt'] = toIso8601String(instance.sentAt);
  val['isRead'] = boolToInt(instance.isRead);
  return val;
}
