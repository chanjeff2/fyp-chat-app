// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_removal_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberRemovalDto _$MemberRemovalDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'senderUserId',
      'chatroomId',
      'sentAt',
      'recipientUserId'
    ],
  );
  return MemberRemovalDto(
    senderUserId: json['senderUserId'] as String,
    recipientUserId: json['recipientUserId'] as String,
    chatroomId: json['chatroomId'] as String,
    sentAt: json['sentAt'] as String,
  );
}

Map<String, dynamic> _$MemberRemovalDtoToJson(MemberRemovalDto instance) =>
    <String, dynamic>{
      'senderUserId': instance.senderUserId,
      'chatroomId': instance.chatroomId,
      'sentAt': instance.sentAt,
      'recipientUserId': instance.recipientUserId,
    };
