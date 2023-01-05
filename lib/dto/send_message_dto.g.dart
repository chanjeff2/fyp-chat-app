// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageDto _$SendMessageDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'senderDeviceId',
      'recipientUserId',
      'messages',
      'sentAt'
    ],
  );
  return SendMessageDto(
    senderDeviceId: json['senderDeviceId'] as int,
    recipientUserId: json['recipientUserId'] as String,
    messages: (json['messages'] as List<dynamic>)
        .map((e) => MessageToServerDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    sentAt: json['sentAt'] as String,
  );
}

Map<String, dynamic> _$SendMessageDtoToJson(SendMessageDto instance) =>
    <String, dynamic>{
      'senderDeviceId': instance.senderDeviceId,
      'recipientUserId': instance.recipientUserId,
      'messages': instance.messages,
      'sentAt': instance.sentAt,
    };
