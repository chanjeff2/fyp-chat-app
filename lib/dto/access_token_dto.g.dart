// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenDto _$AccessTokenDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['accessToken', 'accessTokenExpiresAt'],
  );
  return AccessTokenDto(
    accessToken: json['accessToken'] as String,
    accessTokenExpiresAt: json['accessTokenExpiresAt'] as String,
    refreshToken: json['refreshToken'] as String?,
    refreshTokenExpiresAt: json['refreshTokenExpiresAt'] as String?,
  );
}

Map<String, dynamic> _$AccessTokenDtoToJson(AccessTokenDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'accessTokenExpiresAt': instance.accessTokenExpiresAt,
      'refreshToken': instance.refreshToken,
      'refreshTokenExpiresAt': instance.refreshTokenExpiresAt,
    };
