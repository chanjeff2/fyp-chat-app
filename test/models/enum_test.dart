// write test cases about enum in model
import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/models/enum.dart';

void main() {
  setUpAll(() async {});
  test('test FCMEventType', () async {
    // compare with its index
    expect(FCMEventType.textMessage.index, 0);
    expect(FCMEventType.mediaMessage.index, 1);
    expect(FCMEventType.patchGroup.index, 2);
    expect(FCMEventType.addMember.index, 3);
    expect(FCMEventType.kickMember.index, 4);
    expect(FCMEventType.promoteAdmin.index, 5);
    expect(FCMEventType.demoteAdmin.index, 6);
    expect(FCMEventType.memberJoin.index, 7);
    expect(FCMEventType.memberLeave.index, 8);
  });
  test('test GroupType', () async {
    // compare with its index
    expect(GroupType.Basic.index, 0);
    expect(GroupType.Course.index, 1);
  });
  test('test Role', () async {
    // compare with its index
    expect(Role.member.index, 0);
    expect(Role.admin.index, 1);
  });
  test('test Semester', () async {
    // compare with its index
    expect(Semester.Fall.index, 0);
    expect(Semester.Winter.index, 1);
    expect(Semester.Spring.index, 2);
    expect(Semester.Summer.index, 3);
  });
  test('test ChatroomType', () async {
    // compare with its index
    expect(ChatroomType.oneToOne.index, 0);
    expect(ChatroomType.group.index, 1);
  });
}
