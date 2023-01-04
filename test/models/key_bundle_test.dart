import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/device_key_bundle_dto.dart';
import 'package:fyp_chat_app/dto/key_bundle_dto.dart';
import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:fyp_chat_app/models/key_bundle.dart';
import 'package:fyp_chat_app/models/pre_key.dart';
import 'package:fyp_chat_app/models/signed_pre_key.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

void main() {
  test('serialize and de-serialize', () {
    const deviceId = 1;
    final registrationId = generateRegistrationId(false);
    final identityKeyPair = generateIdentityKeyPair();
    final signedPreKey = generateSignedPreKey(identityKeyPair, 0);
    final preKey = generatePreKeys(0, 1)[0];
    final deviceKeyBundlesDto = [
      DeviceKeyBundleDto(
        deviceId: deviceId,
        registrationId: registrationId,
        signedPreKey: SignedPreKey.fromSignedPreKeyRecord(signedPreKey).toDto(),
        oneTimeKey: PreKey.fromPreKeyRecord(preKey).toDto(),
      ),
    ];
    final keyBundleDto = KeyBundleDto(
      identityKey: identityKeyPair.getPublicKey().encodeToString(),
      deviceKeyBundles: deviceKeyBundlesDto,
    );
    final keyBundle = KeyBundle.fromDto(keyBundleDto);
    expect(
      listEquals(
        keyBundle.identityKey.serialize(),
        identityKeyPair.getPublicKey().serialize(),
      ),
      true,
    );
    expect(keyBundle.deviceKeyBundles[0].deviceId, deviceId);
    expect(keyBundle.deviceKeyBundles[0].registrationId, registrationId);
    expect(keyBundle.deviceKeyBundles[0].oneTimeKey?.id, preKey.id);
    expect(
      keyBundle.deviceKeyBundles[0].oneTimeKey?.key
          .compareTo(preKey.getKeyPair().publicKey),
      0,
    );
    expect(keyBundle.deviceKeyBundles[0].signedPreKey.id, signedPreKey.id);
    expect(
      keyBundle.deviceKeyBundles[0].signedPreKey.key
          .compareTo(signedPreKey.getKeyPair().publicKey),
      0,
    );
    expect(
      listEquals(
        keyBundle.deviceKeyBundles[0].signedPreKey.signature,
        signedPreKey.signature,
      ),
      true,
    );
  });
}
