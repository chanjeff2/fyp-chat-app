import 'package:json_annotation/json_annotation.dart';

part 'register_dto.g.dart';

@JsonSerializable()
class RegisterDto {
  String username;
  String? displayName;
  String password;

  RegisterDto({
    required this.username,
    this.displayName,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$RegisterDtoToJson(this);
}
