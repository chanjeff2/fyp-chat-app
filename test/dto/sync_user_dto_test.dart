import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/access_token_dto.dart';
import 'package:fyp_chat_app/dto/account_dto.dart';
import 'package:fyp_chat_app/dto/login_dto.dart';
import 'package:fyp_chat_app/dto/sync_user_dto.dart';
import 'package:fyp_chat_app/models/access_token.dart';
import 'package:fyp_chat_app/models/account.dart';
import 'package:http/http.dart' as http;

void main() {
  late final SyncUserDto syncUserDto1;
  late final SyncUserDto syncUserDto2;
  late final SyncUserDto syncUserDto3;
  setUpAll(() async {
    //setup
    syncUserDto1 = SyncUserDto(
      id: '63b1948cd256427ee7c981b0',
      updatedAt: "2022-07-01T12:34:56.789Z",
    );

    syncUserDto2 = SyncUserDto(
      id: '63b2a8cc4f9ff0fe20a1aa49',
      updatedAt: "2022-07-01T12:34:56.789Z",
    );

    // With a newer update time
    syncUserDto3 = SyncUserDto(
      id: '63b1948cd256427ee7c981b0',
      updatedAt: "2023-07-01T12:34:56.789Z",
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = syncUserDto1.toJson();
    //de-serialize
    final receivedSyncUserDto = SyncUserDto.fromJson(json);
    //compare
    expect(receivedSyncUserDto.id, syncUserDto1.id);
    expect(receivedSyncUserDto.updatedAt, syncUserDto1.updatedAt);
  });

  test('Get synced info from server', () async {
    const String baseUrl = "https://fyp-chat-server-dev.up.railway.app";

    const String loginPrefix = "/auth";
    const String loginEndpoint = "/login";
    Uri url = Uri.parse("$baseUrl$loginPrefix$loginEndpoint");

    final loginDto = LoginDto(username: "username3", password: "test");
    final loginDtoJson = loginDto.toJson();
    http.Response response = await http.post(
      url,
      headers: null,
      body: loginDtoJson,
    );

    final accessTokenJson = json.decode(response.body);
    final accessTokenDto = AccessTokenDto.fromJson(accessTokenJson);
    final accessTokenObj = AccessToken.fromDto(accessTokenDto);

    final accessToken = accessTokenObj.accessToken;

    const String pathPrefix = "/users";
    const String endPoint = "/sync";

    final body = json.encode({
      "data": [syncUserDto1.toJson(), syncUserDto2.toJson()]
    });

    url = Uri.parse("$baseUrl$pathPrefix$endPoint");
    Map<String, String> headers = {};
    headers['Authorization'] = 'Bearer $accessToken';
    headers['Content-Type'] = 'application/json; charset=UTF-8';
    response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    expect(response.statusCode, 201);

    // parse back to user
    final List<dynamic> responseJson = json.decode(response.body);
    final result = responseJson
        .map((e) => Account.fromDto(AccountDto.fromJson(e)))
        .toList();

    expect(result.length, 2);

    expect(result[0].userId, syncUserDto1.id);
    expect(result[0].username, "test123");
    expect(
        result[0].updatedAt.millisecondsSinceEpoch,
        greaterThanOrEqualTo(
            DateTime.parse(syncUserDto1.updatedAt).millisecondsSinceEpoch));

    expect(result[1].userId, syncUserDto2.id);
    expect(result[1].username, "testabc");
    expect(
        result[1].updatedAt.millisecondsSinceEpoch,
        greaterThanOrEqualTo(
            DateTime.parse(syncUserDto2.updatedAt).millisecondsSinceEpoch));
  });

  test('Get from server, update date newer than server', () async {
    const String baseUrl = "https://fyp-chat-server-dev.up.railway.app";

    const String loginPrefix = "/auth";
    const String loginEndpoint = "/login";
    Uri url = Uri.parse("$baseUrl$loginPrefix$loginEndpoint");

    final loginDto = LoginDto(username: "username3", password: "test");
    final loginDtoJson = loginDto.toJson();
    http.Response response = await http.post(
      url,
      headers: null,
      body: loginDtoJson,
    );

    final accessTokenJson = json.decode(response.body);
    final accessTokenDto = AccessTokenDto.fromJson(accessTokenJson);
    final accessTokenObj = AccessToken.fromDto(accessTokenDto);

    final accessToken = accessTokenObj.accessToken;

    const String pathPrefix = "/users";
    const String endPoint = "/sync";

    final body = json.encode({
      "data": [syncUserDto3.toJson()]
    });

    url = Uri.parse("$baseUrl$pathPrefix$endPoint");
    Map<String, String> headers = {};
    headers['Authorization'] = 'Bearer $accessToken';
    headers['Content-Type'] = 'application/json; charset=UTF-8';
    response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    expect(response.statusCode, 201);

    // parse back to user
    final List<dynamic> responseJson = json.decode(response.body);
    expect(responseJson, []);
  });
}
