import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fyp_chat_app/models/access_token.dart';
import 'package:fyp_chat_app/network/auth_api.dart';
import 'package:fyp_chat_app/storage/credential_store.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiException implements Exception {
  int statusCode;
  String message;
  String? error;

  ApiException(this.statusCode, this.message, this.error);
}

class AccessTokenNotFoundException implements Exception {
  String get message => 'access token not found';
  AccessTokenNotFoundException();
}

abstract class Api {
  // use hostname -I to get wsl2 ip and replace the ip address
  static const String baseUrl = "https://fyp-chat-server-dev.up.railway.app";
  // static const String baseUrl = "https://fyp-chat-server.onrender.com";
  // static const String baseUrl = "http://172.29.138.1:3000";
  abstract String pathPrefix;

  dynamic _processResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = json.decode(response.body);
      log('ApiException: [${response.statusCode}] ${body["message"]}');
      throw ApiException(response.statusCode, body["message"], body["error"]);
    }
    if (response.body.isEmpty) {
      return response.body;
    }
    return json.decode(response.body);
  }

  //
  Uint8List _processJSONlessResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = json.decode(response.body);
      log('ApiException: [${response.statusCode}] ${body["message"]}');
      throw ApiException(response.statusCode, body["message"], body["error"]);
    }
    return response.bodyBytes;
  }

  Future<AccessToken> _getAccessToken() async {
    AccessToken? accessToken = await CredentialStore().getToken();
    if (accessToken != null && !accessToken.isAccessTokenExpired()) {
      // not expired
      return accessToken;
    }
    if (accessToken != null &&
        accessToken.isAccessTokenExpired() &&
        accessToken.refreshToken != null &&
        !accessToken.isRefreshTokenExpired()) {
      // access token expired, refresh token not expired
      log('Api: access token expired. attempt to refresh token.');
      try {
        return await AuthApi().refreshToken(accessToken.refreshToken!);
      } catch (e) {
        // refresh token failed
        log('Api: refresh token failed. error: $e');
      }
    }
    log('Api: attempt to re-login');
    // both expired or token not exist
    final loginDto = await CredentialStore().getCredential();
    if (loginDto == null) {
      // wtf?
      throw AccessTokenNotFoundException();
    }
    return await AuthApi().login(loginDto);
  }

  @protected
  Future<dynamic> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? query,
    bool useAuth = false,
  }) async {
    final url =
        Uri.parse("$baseUrl$pathPrefix$path").replace(queryParameters: query);
    if (useAuth) {
      AccessToken accessToken = await _getAccessToken();
      headers ??= {};
      headers['Authorization'] = 'Bearer ${accessToken.accessToken}';
    }
    final response = await http.get(
      url,
      headers: headers,
    );
    return _processResponse(response);
  }

  @protected
  Future<Uint8List> getMedia(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? query,
    bool useAuth = false,
  }) async {
    final url =
        Uri.parse("$baseUrl$pathPrefix$path").replace(queryParameters: query);
    if (useAuth) {
      AccessToken accessToken = await _getAccessToken();
      headers ??= {};
      headers['Authorization'] = 'Bearer ${accessToken.accessToken}';
    }
    final response = await http.get(
      url,
      headers: headers,
    );
    return _processJSONlessResponse(response);
  }

  @protected
  Future<dynamic> post(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    bool useAuth = false,
  }) async {
    final url = Uri.parse("$baseUrl$pathPrefix$path");
    headers ??= {};
    headers['Content-Type'] = 'application/json; charset=UTF-8';
    if (useAuth) {
      AccessToken accessToken = await _getAccessToken();
      headers['Authorization'] = 'Bearer ${accessToken.accessToken}';
    }
    final response = await http.post(
      url,
      headers: headers,
      body: body != null ? json.encode(body) : null,
    );
    return _processResponse(response);
  }

  // Post function, for media (Uses multipart as content type instead)
  @protected
  Future<dynamic> postMedia(
    String path, {
    Map<String, String>? headers,
    required File file,
    bool useAuth = false,
  }) async {
    final url = Uri.parse("$baseUrl$pathPrefix$path");
    headers ??= {};
    headers['Content-Type'] = 'multipart/form-data';
    if (useAuth) {
      AccessToken accessToken = await _getAccessToken();
      headers['Authorization'] = 'Bearer ${accessToken.accessToken}';
    }
    final request = http.MultipartRequest('POST', url);
    final fileToUpload = await http.MultipartFile.fromPath('file', file.path);
    request.files.add(fileToUpload);
    request.headers.addAll(headers); // Replace headers
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _processResponse(response);
  }

  @protected
  Future<dynamic> putMedia(
    String path, {
      Map<String, String>? headers,
      required File file,
      bool useAuth = false,
      bool profilePic = false,
    }) async {
      final url = Uri.parse("$baseUrl$pathPrefix$path");
      final ext =  file.path.split('.').last;
      headers ??= {};
      headers['Content-Type'] = profilePic ? 'image/$ext' : 'multipart/form-data';
      if (useAuth) {
        AccessToken accessToken = await _getAccessToken();
        headers['Authorization'] = 'Bearer ${accessToken.accessToken}';
      }
      
      final request = http.MultipartRequest('PUT', url);
      final fileToUpload = await http.MultipartFile.fromPath(
        'file', file.path,
        contentType: MediaType('image', ext)
      );
      request.files.add(fileToUpload);
      request.headers.addAll(headers); // Replace headers
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return _processResponse(response);
    }

  @protected
  Future<dynamic> patch(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    bool useAuth = false,
  }) async {
    final url = Uri.parse("$baseUrl$pathPrefix$path");
    headers ??= {};
    headers['Content-Type'] = 'application/json; charset=UTF-8';
    if (useAuth) {
      AccessToken accessToken = await _getAccessToken();
      headers['Authorization'] = 'Bearer ${accessToken.accessToken}';
    }
    final response = await http.patch(
      url,
      headers: headers,
      body: body != null ? json.encode(body) : null,
    );
    return _processResponse(response);
  }

  @protected
  Future<dynamic> delete(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    bool useAuth = false,
  }) async {
    final url = Uri.parse("$baseUrl$pathPrefix$path");
    headers ??= {};
    headers['Content-Type'] = 'application/json; charset=UTF-8';
    if (useAuth) {
      AccessToken accessToken = await _getAccessToken();
      headers['Authorization'] = 'Bearer ${accessToken.accessToken}';
    }
    final response = await http.delete(
      url,
      headers: headers,
      body: body != null ? json.encode(body) : null,
    );
    return _processResponse(response);
  }
}
