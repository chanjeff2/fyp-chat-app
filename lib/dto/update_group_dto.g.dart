// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_group_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateGroupDto _$UpdateGroupDtoFromJson(Map<String, dynamic> json) =>
    UpdateGroupDto(
      name: json['name'] as String?,
      description: json['description'] as String?,
      isPublic: json['isPublic'] as bool?,
    );

Map<String, dynamic> _$UpdateGroupDtoToJson(UpdateGroupDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('isPublic', instance.isPublic);
  return val;
}
