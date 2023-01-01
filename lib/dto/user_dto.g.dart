// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['userId', 'username'],
  );
  return UserDto(
    json['userId'] as String,
    json['username'] as String,
  );
}

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
    };
