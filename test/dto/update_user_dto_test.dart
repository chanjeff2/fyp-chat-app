import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/update_user_dto.dart';

void main() {
  late final UpdateUserDto updateUserDto;
  setUpAll(() async {
    //setup
    updateUserDto = UpdateUserDto(
      displayName: 'displayName',
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = updateUserDto.toJson();
    //de-serialize
    final receivedUpdateUserDto = UpdateUserDto.fromJson(json);
    //compare
    expect(receivedUpdateUserDto.displayName, updateUserDto.displayName);
  });
}
