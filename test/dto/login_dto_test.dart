import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/access_token_dto.dart';
import 'package:fyp_chat_app/dto/login_dto.dart';
import 'package:fyp_chat_app/models/access_token.dart';
import 'package:http/http.dart' as http;

void main() {
  late final LoginDto loginDto;
  setUpAll(() async {
    // setup a login DTO
    // Username and password is the example from Postman
    loginDto = LoginDto(
      username: "username3",
      password: "test"
    );
  });

  test('serialize json', () async {
    // serialize
    final json = loginDto.toJson();
    // compare
    expect(json["username"], loginDto.username);
    expect(json["password"], loginDto.password);
  });

  test('login and get media', () async {
    final jsonBody = loginDto.toJson();
    // The following is a simple resemblance of the POST request
    const String baseUrl = "https://fyp-chat-server-dev.up.railway.app";
    // const String baseUrl = "https://fyp-chat-server.onrender.com";
    String pathPrefix = "/auth";
    String endpoint = "/login";
    Uri url = Uri.parse("$baseUrl$pathPrefix$endpoint");
    http.Response response = await http.post(
      url,
      headers: null,
      body: jsonBody,
    );
    expect(response.statusCode, 200);

    // Convert the response body to DTO
    final decodedJson = json.decode(response.body);
    final accessTokenDto = AccessTokenDto.fromJson(decodedJson);
    final accessTokenObj = AccessToken.fromDto(accessTokenDto);

    final accessToken = accessTokenObj.accessToken;

    // Test: get the user without access token
    const targetId = "6436f09e23378fc9fe7bcc65";
    pathPrefix = "/media";
    endpoint = "/$targetId";
    url = Uri.parse("$baseUrl$pathPrefix$endpoint");

    response = await http.get(
      url,
      headers: null,
    );
    expect(response.statusCode, 401);

    // Test: get the user with access token
    Map<String, String> headers = {};
    headers['Authorization'] = 'Bearer $accessToken';
    response = await http.get(
      url,
      headers: headers,
    );
    expect(response.statusCode, 200);

    // Test: logout
    pathPrefix = "/auth";
    endpoint = "/logout";
    url = Uri.parse("$baseUrl$pathPrefix$endpoint");
    response = await http.post(
      url,
      headers: headers,
    );
    expect(response.statusCode, 200);
  });
}
