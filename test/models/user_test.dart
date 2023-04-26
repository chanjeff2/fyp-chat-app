import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/models/user.dart';
import 'package:fyp_chat_app/dto/user_dto.dart';
import 'package:fyp_chat_app/entities/user_entity.dart';

void main() {
  late final User user;
  late final UserDto userDto;
  setUpAll(() async {
    // setup an account
    user = User(
      userId: "id",
      username: "username",
      displayName: 'displayName',
      status: 'status',
      profilePicUrl:
          "https://storage.googleapis.com/download/storage/test-link-doesnt-link-to-anything",
      updatedAt: DateTime.now(),
    );

    userDto = UserDto(
      userId: "id",
      username: "username",
      displayName: 'displayName',
      status: 'status',
      profilePicUrl:
          "https://storage.googleapis.com/download/storage/test-link-doesnt-link-to-anything",
      updatedAt: DateTime.now().toIso8601String(),
    );
  });
  test('serialize and de-serialize to Entity', () async {
    // serialize
    final entity = user.toEntity();
    // de-serialize
    final receivedUser = User.fromEntity(entity);
    // compare
    expect(receivedUser.userId, user.userId);
    expect(receivedUser.username, user.username);
    expect(receivedUser.displayName, user.displayName);
    expect(receivedUser.status, user.status);
    expect(receivedUser.profilePicUrl, user.profilePicUrl);
    expect(receivedUser.updatedAt, user.updatedAt);
  });

  test('deserialize from DTO', () async {
    // de-serialize
    final receivedUser = User.fromDto(userDto);
    // compare
    expect(receivedUser.userId, userDto.userId);
    expect(receivedUser.username, userDto.username);
    expect(receivedUser.displayName, userDto.displayName);
    expect(receivedUser.status, userDto.status);
    expect(receivedUser.profilePicUrl, userDto.profilePicUrl);
    expect(receivedUser.updatedAt, DateTime.parse(userDto.updatedAt));
  });
}