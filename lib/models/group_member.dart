import 'package:fyp_chat_app/entities/group_member_entity.dart';
import 'package:fyp_chat_app/models/user.dart';

class GroupMember {
  /// id for [GroupMemberEntity]
  final int? id;
  final User user;

  GroupMember({
    this.id,
    required this.user,
  });
}
