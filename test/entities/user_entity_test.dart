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
      profilePicUrl:
          "https://storage.googleapis.com/download/storage/test-link-doesnt-link-to-anything",
      updatedAt: DateTime.now().toIso8601String(),
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
    expect(receivedUserEntity.profilePicUrl, userEntity.profilePicUrl);
    expect(receivedUserEntity.updatedAt, userEntity.updatedAt);
  });
}
