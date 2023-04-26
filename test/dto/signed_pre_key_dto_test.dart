import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/signed_pre_key_dto.dart';

void main() {
  late final SignedPreKeyDto signedPreKeyDto;
  setUpAll(() {
    //setup
    signedPreKeyDto = SignedPreKeyDto(
      1,
      'key',
      'signature',
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = signedPreKeyDto.toJson();
    //de-serialize
    final receivedSignedPreKeyDto = SignedPreKeyDto.fromJson(json);
    //compare
    expect(receivedSignedPreKeyDto.id, signedPreKeyDto.id);
    expect(receivedSignedPreKeyDto.key, signedPreKeyDto.key);
    expect(receivedSignedPreKeyDto.signature, signedPreKeyDto.signature);
  });
}
