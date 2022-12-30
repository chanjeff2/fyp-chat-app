import 'package:fyp_chat_app/dto/pre_key_dto.dart';
import 'package:fyp_chat_app/dto/signed_pre_key_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_keys_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class UpdateKeysDto {
  @JsonKey(required: true)
  int deviceId;
  String? identityKey;
  SignedPreKeyDto? signedPreKey;
  List<PreKeyDto>? oneTimeKeys;

  UpdateKeysDto(
    this.deviceId, {
    this.identityKey,
    this.signedPreKey,
    this.oneTimeKeys,
  });

  Map<String, dynamic> toJson() => _$UpdateKeysDtoToJson(this);

  factory UpdateKeysDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateKeysDtoFromJson(json);
}
