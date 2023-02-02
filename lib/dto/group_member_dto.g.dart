// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMemberDto _$GroupMemberDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['_id', 'role', 'members'],
  );
  return GroupMemberDto(
    user: UserDto.fromJson(json['_id'] as Map<String, dynamic>),
    role: $enumDecode(_$RoleEnumMap, json['role']),
    members: (json['members'] as List<dynamic>)
        .map((e) => GroupMemberDto.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$GroupMemberDtoToJson(GroupMemberDto instance) =>
    <String, dynamic>{
      '_id': instance.user.toJson(),
      'role': _$RoleEnumMap[instance.role]!,
      'members': instance.members.map((e) => e.toJson()).toList(),
    };

const _$RoleEnumMap = {
  Role.member: 'Member',
  Role.admin: 'Admin',
};
