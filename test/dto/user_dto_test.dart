import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/user_dto.dart';

void main() {
  late final UserDto userDto1;
  setUpAll(() async {
    userDto1 = UserDto(
      displayName: "displayName",
      status: "status",
      username: "username",
      userId: '1',
      profilePicUrl:
          "https://storage.googleapis.com/download/storage/test-link-doesnt-link-to-anything",
      updatedAt: DateTime.now().toIso8601String(),
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = userDto1.toJson();
    //de-serialize
    final receivedUserDto = UserDto.fromJson(json);
    //compare
    expect(receivedUserDto.displayName, userDto1.displayName);
    expect(receivedUserDto.status, userDto1.status);
    expect(receivedUserDto.username, userDto1.username);
    expect(receivedUserDto.userId, userDto1.userId);
    expect(receivedUserDto.profilePicUrl, userDto1.profilePicUrl);
    expect(receivedUserDto.updatedAt, userDto1.updatedAt);
  });
}
