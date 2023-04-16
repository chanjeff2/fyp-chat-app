import 'package:fyp_chat_app/dto/group_member_dto.dart';
import 'package:fyp_chat_app/entities/group_member_entity.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/user.dart';

class GroupMember {
  /// id for [GroupMemberEntity]
  final int? id;
  final User user;
  final Role role;

  GroupMember({
    this.id,
    required this.user,
    required this.role,
  });

  @override
  bool operator ==(Object other) => 
    identical(this, other)
    || other is GroupMember 
       && runtimeType == other.runtimeType
       && user.id == other.user.id;

  GroupMember.fromDto(GroupMemberDto dto)
      : id = null,
        user = User.fromDto(dto.user),
        role = dto.role;
}
