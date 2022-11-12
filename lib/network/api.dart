import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  int statusCode;
  String message;
  String error;

  ApiException(this.statusCode, this.message, this.error);
}

abstract class Api {
  // use hostname -I to get wsl2 ip and replace the ip address
  static const String baseUrl = "http://192.168.81.76:3000";
  abstract String pathPrefix;

  Map<String, dynamic> processResponse(http.Response response) {
    final body = json.decode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response.statusCode, body["message"], body["error"]);
    }
    return body;
  }

  @protected
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? query,
    String? bearerToken,
  }) async {
    final url =
        Uri.parse("$baseUrl$pathPrefix$path").replace(queryParameters: query);
    Map<String, String>? headers = null;
    if (bearerToken != null) {
      headers = {'Authorization': 'Bearer $bearerToken'};
    }
    final response = await http.get(
      url,
      headers: headers,
    );
    return processResponse(response);
  }

  @protected
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    String? bearerToken,
  }) async {
    final url = Uri.parse("$baseUrl$pathPrefix$path");
    final headers = <String, String>{};
    headers['Content-Type'] = 'application/json; charset=UTF-8';
    if (bearerToken != null) {
      headers['Authorization'] = 'Bearer $bearerToken';
    }
    final response =
        await http.post(url, headers: headers, body: json.encode(body));
    return processResponse(response);
  }
}
