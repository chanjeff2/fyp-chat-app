import 'package:json_annotation/json_annotation.dart';

part 'file_dto.g.dart';

@JsonSerializable()
class FileDto {
  @JsonKey(required: true)
  final String id;

  @JsonKey(required: true)
  final String name;

  FileDto({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() => _$FileDtoToJson(this);

  factory FileDto.fromJson(Map<String, dynamic> json) =>
      _$FileDtoFromJson(json);
}