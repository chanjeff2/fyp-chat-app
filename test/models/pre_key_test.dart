import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/pre_key_dto.dart';
import 'package:fyp_chat_app/models/pre_key.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

void main() {
  test('serialize and de-serialize', () {
    final record = generatePreKeys(0, 1)[0];
    final preKey = PreKey.fromPreKeyRecord(record);
    final serialized = preKey.toDto().toJson();
    final deSerialized = PreKey.fromDto(PreKeyDto.fromJson(serialized));
    expect(deSerialized.id, record.id);
    expect(deSerialized.key.compareTo(record.getKeyPair().publicKey), 0);
  });
}
