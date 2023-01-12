import 'package:fyp_chat_app/dto/key_bundle_dto.dart';
import 'package:fyp_chat_app/dto/update_keys_dto.dart';
import 'package:fyp_chat_app/models/key_bundle.dart';

import 'api.dart';

class KeysApi extends Api {
  // singleton
  KeysApi._();
  static final KeysApi _instance = KeysApi._();
  factory KeysApi() {
    return _instance;
  }

  @override
  String pathPrefix = "/keys";

  Future<void> updateKeys(UpdateKeysDto dto) async {
    await patch("/update-keys", body: dto.toJson(), useAuth: true);
  }

  Future<KeyBundle> getKeyBundle(String userId, int deviceId) async {
    final json = await get("/$userId/devices/$deviceId", useAuth: true);
    final dto = KeyBundleDto.fromJson(json);
    return KeyBundle.fromDto(dto);
  }

  Future<KeyBundle> getAllKeyBundle(String userId) async {
    final json = await get("/$userId/devices", useAuth: true);
    final dto = KeyBundleDto.fromJson(json);
    return KeyBundle.fromDto(dto);
  }
}
