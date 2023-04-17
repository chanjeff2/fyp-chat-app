import 'package:fyp_chat_app/dto/access_token_dto.dart';

class AccessToken {
  String accessToken;
  DateTime accessTokenExpiresAt;
  String? refreshToken;
  DateTime? refreshTokenExpiresAt;

  AccessToken({
    required this.accessToken,
    required this.accessTokenExpiresAt,
    this.refreshToken,
    this.refreshTokenExpiresAt,
  });

  AccessToken.fromDto(AccessTokenDto dto)
      : accessToken = dto.accessToken,
        accessTokenExpiresAt = DateTime.parse(dto.accessTokenExpiresAt),
        refreshToken = dto.refreshTokenExpiresAt,
        refreshTokenExpiresAt = dto.refreshTokenExpiresAt == null
            ? null
            : DateTime.parse(dto.refreshTokenExpiresAt!);

  AccessTokenDto toDto() => AccessTokenDto(
        accessToken: accessToken,
        accessTokenExpiresAt: accessTokenExpiresAt.toIso8601String(),
        refreshToken: refreshToken,
        refreshTokenExpiresAt: refreshTokenExpiresAt?.toIso8601String(),
      );

  bool isAccessTokenExpired() {
    return DateTime.now().isAfter(accessTokenExpiresAt);
  }

  bool isRefreshTokenExpired() {
    if (refreshTokenExpiresAt == null) {
      return true;
    }
    return DateTime.now().isAfter(refreshTokenExpiresAt!);
  }
}
