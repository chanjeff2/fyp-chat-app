import 'package:fyp_chat_app/dto/pre_key_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'signed_pre_key_dto.g.dart';

@JsonSerializable()
class SignedPreKeyDto extends PreKeyDto {
  @JsonKey(required: true)
  final String signature;

  SignedPreKeyDto(int id, String key, this.signature) : super(id, key);

  @override
  Map<String, dynamic> toJson() => _$SignedPreKeyDtoToJson(this);

  factory SignedPreKeyDto.fromJson(Map<String, dynamic> json) =>
      _$SignedPreKeyDtoFromJson(json);
}
