import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/entities/their_identity_key_entity.dart';
import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

void main() {
  late final TheirIdentityKeyEntity theirIdentityKeyEntity;
  setUpAll(() {
    theirIdentityKeyEntity = TheirIdentityKeyEntity(
        1, 'testId', generateIdentityKeyPair().getPublicKey().encodeToString());
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = theirIdentityKeyEntity.toJson();
    //de-serialize
    final receivedTheirIdentityKeyEntity =
        TheirIdentityKeyEntity.fromJson(json);
    //compare
    expect(receivedTheirIdentityKeyEntity.deviceId,
        theirIdentityKeyEntity.deviceId);
    expect(
        receivedTheirIdentityKeyEntity.userId, theirIdentityKeyEntity.userId);
    expect(receivedTheirIdentityKeyEntity.key, theirIdentityKeyEntity.key);
  });
  test(
    'serialize and deserialize to identity key',
    () async {
      //serialize
      final identityKey = theirIdentityKeyEntity.toIdentityKey();
      //de-serialize
      final receivedIdentityKey = TheirIdentityKeyEntity.fromIdentityKey(
        deviceId: theirIdentityKeyEntity.deviceId,
        userId: theirIdentityKeyEntity.userId,
        key: identityKey,
      ).toIdentityKey();
      //compare
      expect(receivedIdentityKey, identityKey);
    },
  );
}
