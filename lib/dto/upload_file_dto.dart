import 'package:json_annotation/json_annotation.dart';

part 'upload_file_dto.g.dart';

@JsonSerializable()
class UploadFileDto {
  @JsonKey(required: true)
  final List<int> buffer;

  @JsonKey(required: true)
  final String originalname;

  UploadFileDto({
    required this.buffer,
    required this.originalname,
  });

  Map<String, dynamic> toJson() => _$UploadFileDtoToJson(this);

  factory UploadFileDto.fromJson(Map<String, dynamic> json) =>
      _$UploadFileDtoFromJson(json);
}