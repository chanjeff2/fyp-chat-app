import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/user_dto.dart';
import 'package:fyp_chat_app/models/user.dart';
import 'package:http/http.dart' as http;

void main() {
  late final String testUsername1;
  late final String testUsername2;
  late final String testUsername3;
  late final String testUserId1;
  late final String testUserId2;

  const String baseUrl = "https://fyp-chat-server-dev.up.railway.app";
  const String pathPrefix = "/users";
  setUpAll(() async {
    testUsername1 = "curly";
    testUsername2 = "username3"; // same as the example on Postman
    testUsername3 = "jimmy";
    testUserId1 = "637123b305badfff52cb548d"; // same as the example on Postman
    testUserId2 = "651bffdf4627c7417023f480"; // should not exist
  });

  test('get user by username (No display name and status)', () async {
    final endPoint = "/username/$testUsername1";
    final url = Uri.parse(("$baseUrl$pathPrefix$endPoint"));
    final response = await http.get(
      url,
      headers: null,
    );
    expect(response.statusCode, 200);

    // parse back to user
    final responseJson = json.decode(response.body);
    final dto = UserDto.fromJson(responseJson);
    final user = User.fromDto(dto);

    expect(user.userId, "63984c8158f7af689a2da7be");
    expect(user.username, "curly");
    expect(user.displayName, null);
    expect(user.status, null);
  });

  test('get user by username', () async {
    final endPoint = "/username/$testUsername2";
    final url = Uri.parse(("$baseUrl$pathPrefix$endPoint"));
    final response = await http.get(
      url,
      headers: null,
    );
    expect(response.statusCode, 200);

    // parse back to user
    final responseJson = json.decode(response.body);
    final dto = UserDto.fromJson(responseJson);
    final user = User.fromDto(dto);

    expect(user.userId, "637123b305badfff52cb548d");
    expect(user.username, "username3");
    expect(user.displayName, "Jeff");
    expect(user.status, "Hi there I am Jeff");
  });

  test('get user by nickname', () async {
    final endPoint = "/username/$testUsername3";
    final url = Uri.parse(("$baseUrl$pathPrefix$endPoint"));
    final response = await http.get(
      url,
      headers: null,
    );
    expect(response.statusCode, 404);
  });

  test('get user by id', () async {
    final endPoint = "/id/$testUserId1";
    final url = Uri.parse(("$baseUrl$pathPrefix$endPoint"));
    final response = await http.get(
      url,
      headers: null,
    );
    expect(response.statusCode, 200);

    // parse back to user
    final responseJson = json.decode(response.body);
    final dto = UserDto.fromJson(responseJson);
    final user = User.fromDto(dto);

    expect(user.userId, "637123b305badfff52cb548d");
    expect(user.username, "username3");
    expect(user.displayName, "Jeff");
    expect(user.status, "Hi there I am Jeff");
  });

  test('get user by random ID', () async {
    final endPoint = "/username/$testUserId2";
    final url = Uri.parse(("$baseUrl$pathPrefix$endPoint"));
    final response = await http.get(
      url,
      headers: null,
    );
    expect(response.statusCode, 404);
  });
}