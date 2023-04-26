import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/pre_key_dto.dart';

void main() {
  late final PreKeyDto preKeyDto;
  setUpAll(() {
    //setup
    preKeyDto = PreKeyDto(1, 'test');
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = preKeyDto.toJson();
    //de-serialize
    final receivedPreKeyDto = PreKeyDto.fromJson(json);
    //compare
    expect(receivedPreKeyDto.id, preKeyDto.id);
    expect(receivedPreKeyDto.key, preKeyDto.key);
  });
}
