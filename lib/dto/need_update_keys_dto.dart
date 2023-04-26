import 'package:json_annotation/json_annotation.dart';

part 'need_update_keys_dto.g.dart';

@JsonSerializable()
class NeedUpdateKeysDto {
  @JsonKey(required: true)
  final bool signedPreKey;

  @JsonKey(required: true)
  final bool oneTimeKeys;

  NeedUpdateKeysDto({
    required this.signedPreKey,
    required this.oneTimeKeys,
  });

  Map<String, dynamic> toJson() => _$NeedUpdateKeysDtoToJson(this);

  factory NeedUpdateKeysDto.fromJson(Map<String, dynamic> json) =>
      _$NeedUpdateKeysDtoFromJson(json);
}
