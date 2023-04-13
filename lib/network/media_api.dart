
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fyp_chat_app/dto/media_info_dto.dart';
import 'package:fyp_chat_app/dto/upload_file_dto.dart';

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

  Future<MediaInfoDto> uploadFile(UploadFileDto media) async {
    final response = await postMedia("", file: media.toJson(), useAuth: true);
    return MediaInfoDto.fromJson(response); // Need to decrypt the JSON in actual case
  }

  Future<Uint8List> downloadFile(String mediaId) async {
    final response = await get("/$mediaId", useAuth: true);
    return response.bodyBytes; // assume what I obtained is a Uint8List
  }
}
