import 'package:json_annotation/json_annotation.dart';

part 'media_info_dto.g.dart';

@JsonSerializable()
class MediaInfoDto {
  @JsonKey(required: true)
  final String id;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true)
  final String publicUrl; // iso string

  @JsonKey(required: true)
  final String createdAt; // iso string

  @JsonKey(required: true)
  final String updatedAt; // iso string

  MediaInfoDto({
    required this.id,
    required this.name,
    required this.publicUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => _$MediaInfoDtoToJson(this);

  factory MediaInfoDto.fromJson(Map<String, dynamic> json) =>
      _$MediaInfoDtoFromJson(json);
}