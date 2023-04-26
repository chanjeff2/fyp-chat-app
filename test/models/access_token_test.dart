import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/models/access_token.dart';

void main() {
  late final AccessToken accessToken;
  setUpAll(() async {
    // setup a access token
    accessToken = AccessToken(
      accessToken: "accessToken",
      accessTokenExpiresAt: DateTime.now().subtract(const Duration(hours: 5)),
      refreshTokenExpiresAt: null,
    );
  });
  test('serialize and de-serialize', () async {
    // serialize
    final dto = accessToken.toDto();
    // de-serialize
    final receivedAccessToken = AccessToken.fromDto(dto);
    // compare
    expect(receivedAccessToken.accessToken, accessToken.accessToken);

    expect(receivedAccessToken.accessTokenExpiresAt,
        accessToken.accessTokenExpiresAt);
    expect(receivedAccessToken.refreshToken, accessToken.refreshToken);
    expect(receivedAccessToken.refreshTokenExpiresAt,
        accessToken.refreshTokenExpiresAt);
  });

  test('check access token and refresh token expiration', () async {
    // serialize
    final dto = accessToken.toDto();
    // de-serialize
    final receivedAccessToken = AccessToken.fromDto(dto);
    // compare
    expect(receivedAccessToken.isAccessTokenExpired(), true);
    expect(receivedAccessToken.isRefreshTokenExpired(), true);
  });
}
