import 'package:json_annotation/json_annotation.dart';

part 'sync_user_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class SyncUserDto {
  @JsonKey(required: true, name: "_id")
  String id;

  @JsonKey(required: true)
  String updatedAt;

  SyncUserDto({
    required this.id,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => _$SyncUserDtoToJson(this);

  factory SyncUserDto.fromJson(Map<String, dynamic> json) =>
      _$SyncUserDtoFromJson(json);
}
