// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMemberDto _$GroupMemberDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['user', 'role'],
  );
  return GroupMemberDto(
    user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
    role: $enumDecode(_$RoleEnumMap, json['role']),
  );
}

Map<String, dynamic> _$GroupMemberDtoToJson(GroupMemberDto instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'role': _$RoleEnumMap[instance.role]!,
    };

const _$RoleEnumMap = {
  Role.member: 'Member',
  Role.admin: 'Admin',
};
