import 'dart:io';

import 'package:fyp_chat_app/dto/create_group_dto.dart';
import 'package:fyp_chat_app/dto/group_dto.dart';
import 'package:fyp_chat_app/dto/group_member_dto.dart';
import 'package:fyp_chat_app/dto/send_access_control_dto.dart';
import 'package:fyp_chat_app/dto/send_invitation_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';
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
    String userId,
  ) async {
    try {
      var sendAccessControlDto = SendAccessControlDto(
          targetUserId: userId,
          type: FCMEventType.addMember,
          sentAt: DateTime.now());
      final json = await post("/$groupId/access-control",
          body: sendAccessControlDto.toJson(), useAuth: true);
    } catch (e) {
      return;
    }
  }

  Future<bool> kickMember(String groupId, String userId) async {
    try {
      var sendAccessControlDto = SendAccessControlDto(
          targetUserId: userId,
          type: FCMEventType.kickMember,
          sentAt: DateTime.now());
      final json = await post("/$groupId/access-control",
          body: sendAccessControlDto.toJson(), useAuth: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> leaveGroup(String groupId) async {
    try {
      final json = await post("/$groupId/leave", useAuth: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addAdmin(String groupId, String userId) async {
    try {
      var sendAccessControlDto = SendAccessControlDto(
          targetUserId: userId,
          type: FCMEventType.promoteAdmin,
          sentAt: DateTime.now());
      final json = await post("/$groupId/access-control",
          body: sendAccessControlDto.toJson(), useAuth: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeAdmin(String groupId, String userId) async {
    try {
      var sendAccessControlDto = SendAccessControlDto(
          targetUserId: userId,
          type: FCMEventType.demoteAdmin,
          sentAt: DateTime.now());
      final json = await post("/$groupId/access-control",
          body: sendAccessControlDto.toJson(), useAuth: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addMember(String groupId, String userId) async {
    try {
      var sendAccessControlDto = SendAccessControlDto(
          targetUserId: userId,
          type: FCMEventType.addMember,
          sentAt: DateTime.now());
      final json = await post("/$groupId/access-control",
          body: sendAccessControlDto.toJson(), useAuth: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<GroupChat> updateGroupInfo(GroupDto gpDto, String groupId) async {
    final json = await patch("/$groupId", body: gpDto.toJson(), useAuth: true);
    final dto = GroupDto.fromJson(json);
    return GroupChat.fromDto(dto);
  }

  Future<GroupChat> updateProfilePic(File image, String groupId) async {
    final json = await putMedia("/$groupId/update-profile-pic", file: image, useAuth: true);
    final dto = GroupDto.fromJson(json);
    return GroupChat.fromDto(dto);
  }
}
