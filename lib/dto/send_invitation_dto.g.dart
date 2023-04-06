// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_invitation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendInvitationDto _$SendInvitationDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['target', 'sentAt'],
  );
  return SendInvitationDto(
    target: json['target'] as String,
    sentAt: json['sentAt'] as String,
  );
}

Map<String, dynamic> _$SendInvitationDtoToJson(SendInvitationDto instance) =>
    <String, dynamic>{
      'target': instance.target,
      'sentAt': instance.sentAt,
    };
