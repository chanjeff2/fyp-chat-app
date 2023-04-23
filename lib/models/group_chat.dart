import 'package:fyp_chat_app/dto/group_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/group_info.dart';
import 'package:fyp_chat_app/models/group_member.dart';
import 'package:fyp_chat_app/models/chat_message.dart';

class GroupChat extends GroupInfo {
  final List<GroupMember> members;

  GroupChat({
    required String id,
    required this.members,
    required String name,
    ChatMessage? latestMessage,
    required int unread,
    required DateTime createdAt,
    required GroupType groupType,
    String? description,
    String? profilePicUrl,
  }) : super(
          id: id,
          description: description,
          name: name,
          latestMessage: latestMessage,
          unread: unread,
          createdAt: createdAt,
          groupType: groupType,
          profilePicUrl: profilePicUrl,
        );

  GroupChat.fromDto(GroupDto dto)
      : members = dto.members
            .map(
              (e) => GroupMember.fromDto(e),
            )
            .toList(),
        super(
          id: dto.id,
          name: dto.name,
          description: dto.description,
          createdAt: DateTime.parse(dto.createdAt),
          groupType: dto.groupType,
          unread: 0,
          profilePicUrl: dto.profilePicUrl,
        );
}
