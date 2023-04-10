
import 'package:flutter/foundation.dart';
import 'package:fyp_chat_app/entities/media_item_entity.dart';

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

  Future<String> uploadFile(MediaItemEntity dto) async {
    final response = await post("/", body: dto.toJson(), useAuth: true);
    
  }

  Future<Uint8List> getFile(String mediaId) async {
    final json = await get("/file/$mediaId", useAuth: true);
    final dto = KeyBundleDto.fromJson(json);
    return KeyBundle.fromDto(dto);
  }
}
