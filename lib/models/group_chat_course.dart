import 'package:fyp_chat_app/dto/group_dto.dart';
import 'package:fyp_chat_app/entities/chatroom_entity.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/plain_message.dart';

import 'group_member.dart';

class CourseGroup extends GroupChat {
  @override
  ChatroomType get type => ChatroomType.group;
  @override
  GroupChatType get groupType => GroupChatType.course;
  @override
  List<GroupMember> members;

  CourseGroup({
    required String id,
    required this.members,
    required name,
    PlainMessage? latestMessage,
    required int unread,
    required DateTime createdAt,
  }) : super(
            id: id,
            latestMessage: latestMessage,
            unread: unread,
            createdAt: createdAt,
            members: members,
            name: name);

  @override
  ChatroomEntity toEntity() => ChatroomEntity(
        id: id,
        type: type.index,
        name: name,
        createdAt: createdAt.toIso8601String(),
      );

  CourseGroup.fromDto(GroupDto dto)
      : 
      super(
          id: dto.id,
          createdAt: DateTime.parse(dto.createdAt),
          unread: 0,
          members: members = dto.members
            .map(
              (e) => GroupMember.fromDto(e),
            )
            .toList(),
          name: dto.name,
        );
}
