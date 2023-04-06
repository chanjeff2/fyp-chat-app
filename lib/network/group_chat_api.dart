import 'package:fyp_chat_app/dto/create_group_dto.dart';
import 'package:fyp_chat_app/dto/group_dto.dart';
import 'package:fyp_chat_app/dto/group_member_dto.dart';
import 'package:fyp_chat_app/dto/send_invitation_dto.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/group_member.dart';

import 'api.dart';

class GroupChatApi extends Api {
  // singleton
  GroupChatApi._();
  static final GroupChatApi _instance = GroupChatApi._();
  factory GroupChatApi() {
    return _instance;
  }

  @override
  String pathPrefix = "/group-chat";

  Future<GroupChat> createGroup(CreateGroupDto createGroupDto) async {
    final json = await post("", body: createGroupDto.toJson(), useAuth: true);
    final dto = GroupDto.fromJson(json);
    return GroupChat.fromDto(dto);
  }

  Future<GroupChat> joinGroup(String groupId) async {
    final json = await post("/$groupId", useAuth: true);
    final dto = GroupDto.fromJson(json);
    return GroupChat.fromDto(dto);
  }

  Future<GroupChat> getGroup(String groupId) async {
    final json = await get("/$groupId", useAuth: true);
    final dto = GroupDto.fromJson(json);
    return GroupChat.fromDto(dto);
  }

  Future<GroupMember> getGroupMember(String groupId, String userId) async {
    final json = await get("/$groupId/member/$userId", useAuth: true);
    final dto = GroupMemberDto.fromJson(json);
    return GroupMember.fromDto(dto);
  }

  Future<List<GroupChat>> getMyGroups() async {
    final List<dynamic> json = await get("", useAuth: true);
    return json.map((e) => GroupChat.fromDto(GroupDto.fromJson(e))).toList();
  }

  Future<void> inviteMember(
    String groupId,
    SendInvitationDto sendInvitationDto,
  ) async {
    final json = await post(
      "/$groupId/invite",
      body: sendInvitationDto.toJson(),
      useAuth: true,
    );
  }
}
