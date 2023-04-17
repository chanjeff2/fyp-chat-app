// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_group_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGroupDto _$CreateGroupDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name'],
  );
  return CreateGroupDto(
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$CreateGroupDtoToJson(CreateGroupDto instance) =>
    <String, dynamic>{
      'name': instance.name,
    };
