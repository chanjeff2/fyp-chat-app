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
  test('de-serialize from DTO', () async {
    //de-seriailize
    final model = DeviceKeyBundle.fromDto(deviceKeyBundleDto);
    //compare
    expect(model.deviceId, deviceKeyBundleDto.deviceId);
    expect(model.registrationId, deviceKeyBundleDto.registrationId);
    expect(model.signedPreKey.id, deviceKeyBundleDto.signedPreKey.id);
    expect(model.oneTimeKey!.id, deviceKeyBundleDto.oneTimeKey!.id);
  });
}
