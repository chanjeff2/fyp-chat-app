import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/group_member_dto.dart';
import 'package:fyp_chat_app/dto/user_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/group_member.dart';
import 'package:fyp_chat_app/models/user.dart';

void main() {
  late final GroupMemberDto groupMemberDto;
  setUpAll(() async {
    //setup
    groupMemberDto = GroupMemberDto(
        user: UserDto(
          userId: '1',
          username: 'test',
          displayName: 'testDisplayName',
          status: 'testStatus',
          profilePicUrl:
              "https://storage.googleapis.com/download/storage/test-link-doesnt-link-to-anything",
          updatedAt: DateTime.now().toIso8601String(),
        ),
        role: Role.member);
  });
  test('deserialize from DTO', () async {
    //de-seriailize
    final model = GroupMember.fromDto(groupMemberDto);
    //compare
    expect(model.user.id, groupMemberDto.user.userId);
    expect(model.user.username, groupMemberDto.user.username);
    expect(model.user.displayName, groupMemberDto.user.displayName);
    expect(model.user.status, groupMemberDto.user.status);
    expect(model.user.profilePicUrl, groupMemberDto.user.profilePicUrl);
    expect(model.user.updatedAt, DateTime.parse(groupMemberDto.user.updatedAt));
    expect(model.role, groupMemberDto.role);
  });
}
