import 'package:json_annotation/json_annotation.dart';

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.kebab)
enum FCMEventType {
  textMessage,
  mediaMessage,
  patchGroup,
  addMember,
  kickMember,
  promoteAdmin,
  demoteAdmin,
  memberJoin,
  memberLeave,
}

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.kebab)
enum GroupType { Basic, Course }

@JsonEnum(fieldRename: FieldRename.pascal)
enum Role {
  member,
  admin,
}

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.pascal)
enum Semester {
  Fall,
  Winter,
  Spring,
  Summer,
}

enum ChatroomType {
  oneToOne,
  group,
}
