import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/signed_pre_key_dto.dart';
import 'package:fyp_chat_app/models/signed_pre_key.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

void main() {
  test('serialize and de-serialize', () {
    final identityKeyPair = generateIdentityKeyPair();
    final record = generateSignedPreKey(identityKeyPair, 0);
    final signedPreKey = SignedPreKey.fromSignedPreKeyRecord(record);
    final serialized = signedPreKey.toDto().toJson();
    final deSerialized =
        SignedPreKey.fromDto(SignedPreKeyDto.fromJson(serialized));
    expect(deSerialized.id, record.id);
    expect(deSerialized.key.compareTo(record.getKeyPair().publicKey), 0);
    expect(listEquals(deSerialized.signature, record.signature), true);
  });
}
