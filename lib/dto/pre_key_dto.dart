import 'package:json_annotation/json_annotation.dart';

part 'pre_key_dto.g.dart';

@JsonSerializable()
class PreKeyDto {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final String key;

  PreKeyDto(this.id, this.key);

  Map<String, dynamic> toJson() => _$PreKeyDtoToJson(this);

  factory PreKeyDto.fromJson(Map<String, dynamic> json) =>
      _$PreKeyDtoFromJson(json);
}
