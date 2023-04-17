import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/access_token_dto.dart';
import 'package:fyp_chat_app/models/access_token.dart';

void main() {
  late final AccessTokenDto accessTokenDto;
  setUpAll(() async {
    // setup a access token
    accessTokenDto = AccessToken(
      accessToken: "accessToken",
      accessTokenExpiresAt: DateTime.now().subtract(const Duration(hours: 5)),
      refreshTokenExpiresAt: null,
    ).toDto();
  });
  test('serialize and de-serialize json', () async {
    // serialize
    final json = accessTokenDto.toJson();
    // de-serialize
    final receivedAccessTokenDto = AccessTokenDto.fromJson(json);
    // compare
    expect(receivedAccessTokenDto.accessToken, accessTokenDto.accessToken);
    expect(receivedAccessTokenDto.accessTokenExpiresAt,
        accessTokenDto.accessTokenExpiresAt);
    expect(receivedAccessTokenDto.refreshToken, accessTokenDto.refreshToken);
    expect(receivedAccessTokenDto.refreshTokenExpiresAt,
        accessTokenDto.refreshTokenExpiresAt);
  });
}
