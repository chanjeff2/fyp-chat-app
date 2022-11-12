class LoginDto {
  String username;
  String password;

  LoginDto({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["username"] = username;
    json["password"] = password;
    return json;
  }
}
