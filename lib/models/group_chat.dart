import 'package:fyp_chat_app/dto/group_dto.dart';
import 'package:fyp_chat_app/entities/chatroom_entity.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/group_member.dart';
// import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/models/chat_message.dart';

class GroupChat extends Chatroom {
  final List<GroupMember> members;

  @override
  final String name;

  @override
  ChatroomType get type => ChatroomType.group;

  GroupType groupType;

  GroupChat({
    required String id,
    required this.members,
    required this.name,
    ChatMessage? latestMessage,
    required int unread,
    required DateTime createdAt,
    required this.groupType
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
      );

  GroupChat.fromDto(GroupDto dto)
      : groupType = dto.groupType, 
      members = dto.members
            .map(
              (e) => GroupMember.fromDto(e),
            )
            .toList(),
        name = dto.name,
        super(
          id: dto.id,
          createdAt: DateTime.parse(dto.createdAt),
          unread: 0,
        );
}
