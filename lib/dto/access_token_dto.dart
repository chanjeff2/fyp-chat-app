import 'package:json_annotation/json_annotation.dart';

part 'access_token_dto.g.dart';

@JsonSerializable()
class AccessTokenDto {
  @JsonKey(required: true)
  String accessToken;

  AccessTokenDto({
    required this.accessToken,
  });

  factory AccessTokenDto.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenDtoFromJson(json);
}
