class AccessTokenDto {
  String accessToken;

  AccessTokenDto({
    required this.accessToken,
  });

  AccessTokenDto.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'];
}
