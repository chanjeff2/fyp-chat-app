import 'package:fyp_chat_app/dto/group_info_dto.dart';
import 'package:fyp_chat_app/entities/chatroom_entity.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/chat_message.dart';

class GroupInfo extends Chatroom {
  String? description;

  @override
  String? profilePicUrl;

  @override
  String name;

  @override
  ChatroomType get type => ChatroomType.group;

  GroupType groupType;

  GroupInfo({
    required String id,
    required this.name,
    ChatMessage? latestMessage,
    required int unread,
    required DateTime createdAt,
    required this.groupType,
    this.description,
    this.profilePicUrl,
  }) : super(
          id: id,
          latestMessage: latestMessage,
          unread: unread,
          createdAt: createdAt,
        );

  @override
  ChatroomEntity toEntity() => ChatroomEntity(
        id: id,
        type: type.index,
        name: name,
        createdAt: createdAt.toIso8601String(),
        groupType: groupType.index,
        description: description,
        profilePicUrl: profilePicUrl,
      );

  GroupInfo.fromDto(GroupInfoDto dto)
      : groupType = dto.groupType,
        name = dto.name,
        description = dto.description,
        profilePicUrl = dto.profilePicUrl,
        super(
          id: dto.id,
          createdAt: DateTime.parse(dto.createdAt),
          unread: 0,
        );
}
