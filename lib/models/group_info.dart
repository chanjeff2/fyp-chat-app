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

  final GroupType groupType;

  @override
  DateTime updatedAt;

  GroupInfo({
    required String id,
    required this.name,
    ChatMessage? latestMessage,
    required int unread,
    required DateTime createdAt,
    required this.updatedAt,
    required this.groupType,
    this.description,
    this.profilePicUrl,
    bool isMuted = false,
  }) : super(
          id: id,
          latestMessage: latestMessage,
          unread: unread,
          createdAt: createdAt,
          isMuted: isMuted,
        );

  @override
  ChatroomEntity toEntity() => ChatroomEntity(
        id: id,
        type: type.index,
        name: name,
        createdAt: createdAt.toIso8601String(),
        updatedAt: updatedAt.toIso8601String(),
        groupType: groupType.index,
        description: description,
        profilePicUrl: profilePicUrl,
        isMuted: isMuted ? 1 : 0,
      );

  GroupInfo.fromDto(GroupInfoDto dto)
      : groupType = dto.groupType,
        name = dto.name,
        description = dto.description,
        profilePicUrl = dto.profilePicUrl,
        updatedAt = DateTime.parse(dto.updatedAt),
        super(
          id: dto.id,
          createdAt: DateTime.parse(dto.createdAt),
          unread: 0,
        );
}
