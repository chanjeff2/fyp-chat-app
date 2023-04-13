import 'package:json_annotation/json_annotation.dart';

part 'media_key_item_dto.g.dart';

@JsonSerializable()
class MediaKeyItemDto {

  @JsonKey(required: true)
  final String type;

  @JsonKey(required: true)
  final String baseName;

  @JsonKey(required: true)
  final List<int> aesKey;

  @JsonKey(required: true)
  final List<int> iv;

  @JsonKey(required: true)
  final String mediaId;

  MediaKeyItemDto({
    required this.type,
    required this.baseName,
    required this.aesKey,
    required this.iv,
    required this.mediaId,
  });

  Map<String, dynamic> toJson() => _$MediaKeyItemDtoToJson(this);

  factory MediaKeyItemDto.fromJson(Map<String, dynamic> json) =>
      _$MediaKeyItemDtoFromJson(json);
}