import 'package:json_annotation/json_annotation.dart';

part 'access_token_dto.g.dart';

@JsonSerializable()
class AccessTokenDto {
  @JsonKey(required: true)
  String accessToken;

  @JsonKey(required: true)
  String accessTokenExpiresAt;

  String? refreshToken;

  String? refreshTokenExpiresAt;

  AccessTokenDto({
    required this.accessToken,
    required this.accessTokenExpiresAt,
    this.refreshToken,
    this.refreshTokenExpiresAt,
  });

  factory AccessTokenDto.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AccessTokenDtoToJson(this);
}
