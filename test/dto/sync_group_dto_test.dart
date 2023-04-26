import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/access_token_dto.dart';
import 'package:fyp_chat_app/dto/login_dto.dart';
import 'package:fyp_chat_app/dto/sync_group_dto.dart';
import 'package:fyp_chat_app/dto/update_group_dto.dart';
import 'package:fyp_chat_app/models/access_token.dart';
import 'package:http/http.dart' as http;

void main() {
  late final SyncGroupDto syncGroupDto1;
  late final SyncGroupDto syncGroupDto2;
  late final SyncGroupDto syncGroupDto3;
  setUpAll(() async {
    //setup
    syncGroupDto1 = SyncGroupDto(
      id: '63de5d8d0725c622fc7be6c2',
      updatedAt: "2022-07-01T12:34:56.789Z",
    );

    syncGroupDto2 = SyncGroupDto(
      id: '642845aa7f00c2c1fa15ecc7',
      updatedAt: "2022-07-01T12:34:56.789Z",
    );

    // With a newer update time
    syncGroupDto3 = SyncGroupDto(
      id: '63de5d8d0725c622fc7be6c2',
      updatedAt: "2023-07-01T12:34:56.789Z",
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = syncGroupDto1.toJson();
    //de-serialize
    final receivedSyncGroupDto = SyncGroupDto.fromJson(json);
    //compare
    expect(receivedSyncGroupDto.id, syncGroupDto1.id);
    expect(receivedSyncGroupDto.updatedAt, syncGroupDto1.updatedAt);
  });

  test('Get synced info from server', () async {
    const String baseUrl = "https://fyp-chat-server-dev.up.railway.app";
    // const String baseUrl = "https://fyp-chat-server.onrender.com";
    // static const String baseUrl = "http://172.29.138.1:3000";

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

    const String pathPrefix = "/group-chat";
    const String endPoint = "/sync";

    final body = json.encode({
      "data": [syncGroupDto1.toJson(), syncGroupDto2.toJson()]
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
    final result = responseJson.map((e) => UpdateGroupDto.fromJson(e)).toList();

    expect(result.length, 2);

    expect(result[0].name, "testing");
    expect(result[0].description, null);
    expect(result[0].isPublic, false);

    expect(result[1].name, "fg");
    expect(result[1].description, null);
    expect(result[0].isPublic, false);
  });

  test('Get from server, update date newer than server', () async {
    const String baseUrl = "https://fyp-chat-server-dev.up.railway.app";
    // const String baseUrl = "https://fyp-chat-server.onrender.com";
    // static const String baseUrl = "http://172.29.138.1:3000";

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

    const String pathPrefix = "/group-chat";
    const String endPoint = "/sync";

    final body = json.encode({
      "data": [syncGroupDto3.toJson()]
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
