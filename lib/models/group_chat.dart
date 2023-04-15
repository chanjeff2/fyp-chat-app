import 'package:fyp_chat_app/dto/group_dto.dart';
import 'package:fyp_chat_app/entities/chatroom_entity.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/group_member.dart';
import 'package:fyp_chat_app/models/plain_message.dart';




class GroupChat extends Chatroom {
  final List<GroupMember> members;

  @override
  final String name;

  @override
  ChatroomType get type => ChatroomType.group;

  GroupChat({
    required String id,
    required this.members,
    required this.name,
    PlainMessage? latestMessage,
    required int unread,
    required DateTime createdAt,
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
      );

  GroupChat.fromDto(GroupDto dto)
      : members = dto.members
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
