import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/device_key_bundle_dto.dart';
import 'package:fyp_chat_app/models/device_key_bundle.dart';
import 'package:fyp_chat_app/models/pre_key.dart';
import 'package:fyp_chat_app/models/signed_pre_key.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

void main() {
  late final DeviceKeyBundleDto deviceKeyBundleDto;
  setUpAll(() async {
    //setup
    final identityKeyPair = generateIdentityKeyPair();
    final signedPreKey = generateSignedPreKey(identityKeyPair, 0);
    final preKey = generatePreKeys(0, 1)[0];

    deviceKeyBundleDto = DeviceKeyBundleDto(
      deviceId: 1,
      registrationId: generateRegistrationId(false),
      signedPreKey: SignedPreKey.fromSignedPreKeyRecord(signedPreKey).toDto(),
      oneTimeKey: PreKey.fromPreKeyRecord(preKey).toDto(),
    );
  });
  test('serialize and de-serialize to json', () async {
    // serialize
    final json = deviceKeyBundleDto.toJson();
    // de-serialize
    final receivedDto = DeviceKeyBundleDto.fromJson(json);
    // compare
    expect(receivedDto.deviceId, deviceKeyBundleDto.deviceId);
    expect(receivedDto.registrationId, deviceKeyBundleDto.registrationId);
    expect(receivedDto.signedPreKey.key, deviceKeyBundleDto.signedPreKey.key);
    expect(receivedDto.oneTimeKey!.key, deviceKeyBundleDto.oneTimeKey!.key);
  });
}
