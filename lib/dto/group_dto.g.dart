// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupDto _$GroupDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['_id', 'name', 'members', 'createdAt', 'groupType'],
  );
  return GroupDto(
    id: json['_id'] as String,
    name: json['name'] as String,
    members: (json['members'] as List<dynamic>)
        .map((e) => GroupMemberDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    createdAt: json['createdAt'] as String,
    groupType: $enumDecode(_$GroupTypeEnumMap, json['groupType']),
    description: json['description'] as String?,
  );
}

Map<String, dynamic> _$GroupDtoToJson(GroupDto instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'members': instance.members.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt,
      'groupType': _$GroupTypeEnumMap[instance.groupType]!,
      'description': instance.description,
    };

const _$GroupTypeEnumMap = {
  GroupType.Basic: 'basic',
  GroupType.Course: 'course',
};
