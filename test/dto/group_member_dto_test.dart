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
        ),
        role: Role.member);
  });
  test('serialize and deserialize from json', () async {
    //serialize
    final json = groupMemberDto.toJson();
    //de-seriailize
    final model = GroupMemberDto.fromJson(json);
    //compare
    expect(model.user.userId, groupMemberDto.user.userId);
    expect(model.user.username, groupMemberDto.user.username);
    expect(model.user.displayName, groupMemberDto.user.displayName);
    expect(model.user.status, groupMemberDto.user.status);
    expect(model.role, groupMemberDto.role);
  });
}
