import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract class Api {
  // Android is 10.0.2.2 not localhost
  static const String baseUrl = "http://10.0.2.2:3000";
  abstract String pathPrefix;

  @protected
  Future<http.Response> get(
    String path, {
    Map<String, String>? query,
  }) async {
    final url =
        Uri.parse("$baseUrl$pathPrefix$path").replace(queryParameters: query);
    final response = await http.get(url);
    return response;
  }

  @protected
  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse("$baseUrl/$pathPrefix/$path");
    final response = await http.post(url, body: json.encode(body));
    return response;
  }
}
