import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/entities/group_member_entity.dart';
import 'package:fyp_chat_app/models/enum.dart';

void main() {
  late final GroupMemberEntity groupMemberEntity;
  setUpAll(() async {
    groupMemberEntity = GroupMemberEntity(
      id: 1,
      chatroomId: 'test',
      userId: 'test',
      role: Role.admin,
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = groupMemberEntity.toJson();
    //de-serialize
    final receivedGroupMemberEntity = GroupMemberEntity.fromJson(json);
    //compare
    expect(receivedGroupMemberEntity.id, groupMemberEntity.id);
    expect(receivedGroupMemberEntity.chatroomId, groupMemberEntity.chatroomId);
    expect(receivedGroupMemberEntity.userId, groupMemberEntity.userId);
    expect(receivedGroupMemberEntity.role, groupMemberEntity.role);
  });
}
