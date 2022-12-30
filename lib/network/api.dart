import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fyp_chat_app/dto/access_token_dto.dart';
import 'package:fyp_chat_app/storage/credential_store.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  int statusCode;
  String message;
  String error;

  ApiException(this.statusCode, this.message, this.error);
}

class AccessTokenNotFoundException implements Exception {
  String get message => 'access token not found';
  AccessTokenNotFoundException();
}

abstract class Api {
  // use hostname -I to get wsl2 ip and replace the ip address
  static const String baseUrl =
      "https://fyp-chat-server-production.up.railway.app";
  // static const String baseUrl = "https://fyp-chat-server.onrender.com";
  // static const String baseUrl = "http://localhost:3000";
  abstract String pathPrefix;

  dynamic _processResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = json.decode(response.body);
      throw ApiException(response.statusCode, body["message"], body["error"]);
    }
    if (response.body.isEmpty) {
      return response.body;
    }
    return json.decode(response.body);
  }

  @protected
  Future<dynamic> get(
    String path, {
    Map<String, String>? query,
    bool useAuth = false,
  }) async {
    final url =
        Uri.parse("$baseUrl$pathPrefix$path").replace(queryParameters: query);
    Map<String, String>? headers = null;
    if (useAuth) {
      AccessTokenDto? accessTokenDto = await CredentialStore().getToken();
      if (accessTokenDto == null) {
        throw AccessTokenNotFoundException();
      }
      headers = {'Authorization': 'Bearer ${accessTokenDto.accessToken}'};
    }
    final response = await http.get(
      url,
      headers: headers,
    );
    return _processResponse(response);
  }

  @protected
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool useAuth = false,
  }) async {
    final url = Uri.parse("$baseUrl$pathPrefix$path");
    final headers = <String, String>{};
    headers['Content-Type'] = 'application/json; charset=UTF-8';
    if (useAuth) {
      AccessTokenDto? accessTokenDto = await CredentialStore().getToken();
      if (accessTokenDto == null) {
        throw AccessTokenNotFoundException();
      }
      headers['Authorization'] = 'Bearer ${accessTokenDto.accessToken}';
    }
    final response =
        await http.post(url, headers: headers, body: json.encode(body));
    return _processResponse(response);
  }

  @protected
  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? body,
    bool useAuth = false,
  }) async {
    final url = Uri.parse("$baseUrl$pathPrefix$path");
    final headers = <String, String>{};
    headers['Content-Type'] = 'application/json; charset=UTF-8';
    if (useAuth) {
      AccessTokenDto? accessTokenDto = await CredentialStore().getToken();
      if (accessTokenDto == null) {
        throw AccessTokenNotFoundException();
      }
      headers['Authorization'] = 'Bearer ${accessTokenDto.accessToken}';
    }
    final response =
        await http.patch(url, headers: headers, body: json.encode(body));
    return _processResponse(response);
  }
}
