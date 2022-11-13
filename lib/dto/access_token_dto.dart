import 'package:json_annotation/json_annotation.dart';

part 'access_token_dto.g.dart';

@JsonSerializable()
class AccessTokenDto {
  @JsonKey(required: true)
  String accessToken;

  @JsonKey(required: true)
  String refreshToken;

  AccessTokenDto({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AccessTokenDto.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenDtoFromJson(json);
}
