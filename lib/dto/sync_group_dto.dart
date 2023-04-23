import 'package:json_annotation/json_annotation.dart';

part 'sync_group_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class SyncGroupDto {
  @JsonKey(required: true, name: "_id")
  String id;

  @JsonKey(required: true)
  String updatedAt;

  SyncGroupDto({
    required this.id,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => _$SyncGroupDtoToJson(this);

  factory SyncGroupDto.fromJson(Map<String, dynamic> json) =>
      _$SyncGroupDtoFromJson(json);
}
