import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/user_dto.dart';

void main() {
  late final UserDto userDto;
  setUpAll(() async {
    userDto = UserDto(
      displayName: "displayName",
      status: "status",
      username: "username",
      userId: '1',
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = userDto.toJson();
    //de-serialize
    final receivedUserDto = UserDto.fromJson(json);
    //compare
    expect(receivedUserDto.displayName, userDto.displayName);
    expect(receivedUserDto.status, userDto.status);
    expect(receivedUserDto.username, userDto.username);
    expect(receivedUserDto.userId, userDto.userId);
  });
}
