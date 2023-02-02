import 'package:fyp_chat_app/dto/create_group_dto.dart';
import 'package:fyp_chat_app/dto/group_dto.dart';
import 'package:fyp_chat_app/models/group_chat.dart';

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
}
