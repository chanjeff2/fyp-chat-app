import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/entities/pre_key_pair_entity.dart';
import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

void main() {
  late final PreKeyPairEntity preKeyPairEntity;
  late final List<PreKeyRecord> preKeyRecords;
  setUpAll(() {
    preKeyRecords = generatePreKeys(0, 1);
    preKeyPairEntity = PreKeyPairEntity(
        preKeyRecords[0].id, preKeyRecords[0].encodeToString());
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = preKeyPairEntity.toJson();
    //de-serialize
    final receivedPreKeyPairEntity = PreKeyPairEntity.fromJson(json);
    //compare
    expect(receivedPreKeyPairEntity.id, preKeyPairEntity.id);
    expect(receivedPreKeyPairEntity.keyPair, preKeyPairEntity.keyPair);
  });
  test('serialize and deserialize to pre key pair record', () async {
    //serialize
    final preKeyPairRecord = preKeyPairEntity.toPreKeyRecord();
    //de-serialize
    final receivedPreKeyPairRecord =
        PreKeyPairEntity.fromPreKeyRecord(preKeyPairRecord);

    //compare
    expect(receivedPreKeyPairRecord.id, preKeyPairEntity.id);
    expect(receivedPreKeyPairRecord.keyPair, preKeyPairEntity.keyPair);
  });
}
