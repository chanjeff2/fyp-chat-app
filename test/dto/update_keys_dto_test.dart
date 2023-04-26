import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/update_keys_dto.dart';
import 'package:fyp_chat_app/models/signed_pre_key.dart';

void main() {
  late final UpdateKeysDto updateKeysDto;
  setUpAll(() async {
    updateKeysDto = UpdateKeysDto(1,
        identityKey: 'identityKey', signedPreKey: null, oneTimeKeys: []);
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = updateKeysDto.toJson();
    //de-serialize
    final receivedUpdateKeysDto = UpdateKeysDto.fromJson(json);
    //compare
    expect(receivedUpdateKeysDto.deviceId, updateKeysDto.deviceId);
    expect(receivedUpdateKeysDto.identityKey, updateKeysDto.identityKey);
    expect(receivedUpdateKeysDto.signedPreKey, updateKeysDto.signedPreKey);
    expect(receivedUpdateKeysDto.oneTimeKeys, updateKeysDto.oneTimeKeys);
  });
}
