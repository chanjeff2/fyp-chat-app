import '../dto/key_bundle_dto.dart';
import '../dto/update_keys_dto.dart';
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

  Future<KeyBundleDto> getKeyBundle(String userId, int deviceId) async {
    final json = await get("/$userId/devices/$deviceId", useAuth: true);
    return KeyBundleDto.fromJson(json);
  }

  Future<KeyBundleDto> getAllKeyBundle(String userId) async {
    final json = await get("/$userId/devices", useAuth: true);
    return KeyBundleDto.fromJson(json);
  }
}
