import 'package:json_annotation/json_annotation.dart';

part 'media_key_item_dto.g.dart';

@JsonSerializable()
class MediaKeyItemDto {

  @JsonKey(required: true)
  final int type;

  @JsonKey(required: true)
  final String ext;

  @JsonKey(required: true)
  final List<int> aesKey;

  @JsonKey(required: true)
  final List<int> iv;

  MediaKeyItemDto({
    required this.type,
    required this.ext,
    required this.aesKey,
    required this.iv,
  });

  Map<String, dynamic> toJson() => _$MediaKeyItemDtoToJson(this);

  factory MediaKeyItemDto.fromJson(Map<String, dynamic> json) =>
      _$MediaKeyItemDtoFromJson(json);
}