import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/entities/signed_pre_key_pair_entity.dart';
import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

void main() {
  late final SignedPreKeyPairEntity signedPreKeyPairEntity;
  setUpAll(() {
    final identityKeyPair = generateIdentityKeyPair();
    final record = generateSignedPreKey(identityKeyPair, 0);
    signedPreKeyPairEntity =
        SignedPreKeyPairEntity(record.id, record.encodeToString());
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = signedPreKeyPairEntity.toJson();
    //de-serialize
    final receivedSignedPreKeyPairEntity =
        SignedPreKeyPairEntity.fromJson(json);
    //compare
    expect(receivedSignedPreKeyPairEntity.id, signedPreKeyPairEntity.id);
    expect(
        receivedSignedPreKeyPairEntity.keyPair, signedPreKeyPairEntity.keyPair);
  });
  test('serialize and deserialize to signed pre key pair record', () async {
    //serialize
    final signedPreKeyPairRecord =
        signedPreKeyPairEntity.toSignedPreKeyRecord();
    //de-serialize
    final receivedSignedPreKeyPairRecord =
        SignedPreKeyPairEntity.fromSignedPreKeyRecord(signedPreKeyPairRecord);

    //compare
    expect(receivedSignedPreKeyPairRecord.id, signedPreKeyPairEntity.id);
    expect(
        receivedSignedPreKeyPairRecord.keyPair, signedPreKeyPairEntity.keyPair);
  });
}
