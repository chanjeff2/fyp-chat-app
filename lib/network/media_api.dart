
import 'package:flutter/foundation.dart';
import 'package:fyp_chat_app/dto/media_info_dto.dart';

import 'api.dart';

class MediaApi extends Api {
  // singleton
  MediaApi._();
  static final MediaApi _instance = MediaApi._();
  factory MediaApi() {
    return _instance;
  }

  @override
  String pathPrefix = "/media";

  Future<MediaInfoDto> uploadFile(Uint8List media) async {
    final response = await postMedia("", file: media, useAuth: true);
    return MediaInfoDto.fromJson(response); // Need to decrypt the JSON in actual case
  }
}
