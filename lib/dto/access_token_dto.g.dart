// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenDto _$AccessTokenDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['accessToken'],
  );
  return AccessTokenDto(
    accessToken: json['accessToken'] as String,
  );
}

Map<String, dynamic> _$AccessTokenDtoToJson(AccessTokenDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
    };
