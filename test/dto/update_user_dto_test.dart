import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/update_user_dto.dart';

void main() {
  late final UpdateUserDto updateUserDto1;
  late final UpdateUserDto updateUserDto2;
  setUpAll(() async {
    //setup
    updateUserDto1 = UpdateUserDto(
      displayName: 'displayName',
    );

    updateUserDto2 = UpdateUserDto(
      status: 'This is some status',
    );
  });
  test('serialize and deserialize to json, display name only', () async {
    //serialize
    final json = updateUserDto1.toJson();
    //de-serialize
    final receivedUpdateUserDto = UpdateUserDto.fromJson(json);
    //compare
    expect(receivedUpdateUserDto.displayName, updateUserDto1.displayName);
    expect(receivedUpdateUserDto.status, null);
  });

  test('serialize and deserialize to json, status only', () async {
    //serialize
    final json = updateUserDto2.toJson();
    //de-serialize
    final receivedUpdateUserDto = UpdateUserDto.fromJson(json);
    //compare
    expect(receivedUpdateUserDto.displayName, null);
    expect(receivedUpdateUserDto.status, updateUserDto2.status);
  });
}
