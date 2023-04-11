
import 'package:flutter/foundation.dart';

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

  Future<String> uploadFile(Uint8List media) async {
    final response = await postMedia("", file: media, useAuth: true);
    return response; // Need to decrypt the JSON in actual case
  }

  Future<Uint8List> getFile(String mediaId) async {
    final encryptedMediaContent = await getMedia("/file/$mediaId", useAuth: true);
    return encryptedMediaContent;
  }
}
