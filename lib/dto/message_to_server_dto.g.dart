// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_to_server_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageToServerDto _$MessageToServerDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'cipherTextType',
      'recipientDeviceId',
      'recipientRegistrationId',
      'content'
    ],
  );
  return MessageToServerDto(
    cipherTextType: json['cipherTextType'] as int,
    recipientDeviceId: json['recipientDeviceId'] as int,
    recipientRegistrationId: json['recipientRegistrationId'] as int,
    content: json['content'] as String,
  );
}

Map<String, dynamic> _$MessageToServerDtoToJson(MessageToServerDto instance) =>
    <String, dynamic>{
      'cipherTextType': instance.cipherTextType,
      'recipientDeviceId': instance.recipientDeviceId,
      'recipientRegistrationId': instance.recipientRegistrationId,
      'content': instance.content,
    };
