import 'package:json_annotation/json_annotation.dart';

part 'login_dto.g.dart';

@JsonSerializable()
class LoginDto {
  String username;
  String password;

  LoginDto({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$LoginDtoToJson(this);
}
