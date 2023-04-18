import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/entities/user_entity.dart';

void main() {
  late final UserEntity userEntity;
  setUpAll(() {
    userEntity = UserEntity(
      userId: 'test',
      username: 'test',
      displayName: 'test',
      status: 'test',
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = userEntity.toJson();
    //de-serialize
    final receivedUserEntity = UserEntity.fromJson(json);
    //compare
    expect(receivedUserEntity.userId, userEntity.userId);
    expect(receivedUserEntity.username, userEntity.username);
    expect(receivedUserEntity.displayName, userEntity.displayName);
    expect(receivedUserEntity.status, userEntity.status);
  });
}
