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
    );

    userDto = UserDto(
      userId: "id",
      username: "username",
      displayName: 'displayName',
      status: 'status',
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
  });

  test('deserialize from DTO', () async {
    // de-serialize
    final receivedUser = User.fromDto(userDto);
    // compare
    expect(receivedUser.userId, userDto.userId);
    expect(receivedUser.username, userDto.username);
    expect(receivedUser.displayName, userDto.displayName);
    expect(receivedUser.status, userDto.status);
  });

  test('serialize and de-serialize DTO to JSON', () async {
    // serialize
    final json = userDto.toJson();
    // de-serialize
    final receivedDto = UserDto.fromJson(json);
    // compare
    expect(receivedDto.userId, userDto.userId);
    expect(receivedDto.username, userDto.username);
    expect(receivedDto.displayName, userDto.displayName);
    expect(receivedDto.status, userDto.status);
  });

  test('serialize and de-serialize Entity to JSON', () async {
    final entity = user.toEntity();
    // serialize
    final json = entity.toJson();
    // de-serialize
    final receivedEntity = UserEntity.fromJson(json);
    // compare
    expect(receivedEntity.userId, entity.userId);
    expect(receivedEntity.username, entity.username);
    expect(receivedEntity.displayName, entity.displayName);
    expect(receivedEntity.status, entity.status);
  });
}