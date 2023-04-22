import 'package:fyp_chat_app/dto/user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_dto.g.dart';

@JsonSerializable()
class AccountDto extends UserDto {
  AccountDto({
    required String userId,
    required String username,
    String? displayName,
    String? status,
    String? profilePicUrl,
  }) : super(
          userId: userId,
          username: username,
          displayName: displayName,
          status: status,
          profilePicUrl: profilePicUrl,
        );

  @override
  Map<String, dynamic> toJson() => _$AccountDtoToJson(this);

  factory AccountDto.fromJson(Map<String, dynamic> json) =>
      _$AccountDtoFromJson(json);
}
