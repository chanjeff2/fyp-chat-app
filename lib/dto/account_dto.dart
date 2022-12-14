import 'package:json_annotation/json_annotation.dart';

part 'account_dto.g.dart';

@JsonSerializable()
class AccountDto {
  @JsonKey(required: true)
  String userId;

  @JsonKey(required: true)
  String username;
  String? displayName;

  String get name => displayName ?? username;

  AccountDto({
    required this.userId,
    required this.username,
    this.displayName,
  });

  Map<String, dynamic> toJson() => _$AccountDtoToJson(this);

  factory AccountDto.fromJson(Map<String, dynamic> json) =>
      _$AccountDtoFromJson(json);
}
