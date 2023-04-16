import 'dart:io';

import 'package:fyp_chat_app/dto/file_dto.dart';

import 'api.dart';
import 'package:http/http.dart' as http;

class MediaApi extends Api {
  // singleton
  MediaApi._();
  static final MediaApi _instance = MediaApi._();
  factory MediaApi() {
    return _instance;
  }

  @override
  String pathPrefix = "/media";

  Future<FileDto> uploadFile(File media) async {
    final response = await postMedia("", file: media, useAuth: true);
    return FileDto.fromJson(response); // Need to decrypt the JSON in actual case
  }

  Future<dynamic> downloadFile(String mediaId) async {
    final response = await getMedia("/$mediaId", useAuth: true);
    return response;
  }
}
