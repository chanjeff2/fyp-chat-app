// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupInfoDto _$GroupInfoDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['_id', 'name', 'createdAt', 'groupType'],
  );
  return GroupInfoDto(
    id: json['_id'] as String,
    name: json['name'] as String,
    createdAt: json['createdAt'] as String,
    groupType: $enumDecode(_$GroupTypeEnumMap, json['groupType']),
    description: json['description'] as String?,
    profilePicUrl: json['profilePicUrl'] as String?,
  );
}

Map<String, dynamic> _$GroupInfoDtoToJson(GroupInfoDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt,
      'groupType': _$GroupTypeEnumMap[instance.groupType]!,
      'description': instance.description,
      'profilePicUrl': instance.profilePicUrl,
    };

const _$GroupTypeEnumMap = {
  GroupType.Basic: 'basic',
  GroupType.Course: 'course',
};
