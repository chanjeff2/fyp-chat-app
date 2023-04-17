// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMemberEntity _$GroupMemberEntityFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['chatroomId', 'userId', 'role'],
  );
  return GroupMemberEntity(
    id: json['id'] as int?,
    chatroomId: json['chatroomId'] as String,
    userId: json['userId'] as String,
    role: $enumDecode(_$RoleEnumMap, json['role']),
  );
}

Map<String, dynamic> _$GroupMemberEntityToJson(GroupMemberEntity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['chatroomId'] = instance.chatroomId;
  val['userId'] = instance.userId;
  val['role'] = _$RoleEnumMap[instance.role]!;
  return val;
}

const _$RoleEnumMap = {
  Role.member: 'Member',
  Role.admin: 'Admin',
};
