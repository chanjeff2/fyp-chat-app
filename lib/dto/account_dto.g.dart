// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountDto _$AccountDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['userId', 'username'],
  );
  return AccountDto(
    userId: json['userId'] as String,
    username: json['username'] as String,
    displayName: json['displayName'] as String?,
    status: json['status'] as String?,
    profilePicUrl: json['profilePicUrl'] as String?,
    updatedAt: json['updatedAt'] as String,
  );
}

Map<String, dynamic> _$AccountDtoToJson(AccountDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'displayName': instance.displayName,
      'status': instance.status,
      'profilePicUrl': instance.profilePicUrl,
      'updatedAt': instance.updatedAt,
    };
