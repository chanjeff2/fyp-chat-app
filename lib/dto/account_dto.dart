import 'package:json_annotation/json_annotation.dart';

part 'account_dto.g.dart';

@JsonSerializable()
class AccountDto {
  @JsonKey(required: true)
  String userId;

  @JsonKey(required: true)
  String username;
  String? displayName;

  AccountDto({
    required this.userId,
    required this.username,
    this.displayName,
  });

  factory AccountDto.fromJson(Map<String, dynamic> json) =>
      _$AccountDtoFromJson(json);
}
