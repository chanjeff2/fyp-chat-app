class RegisterDto {
  String username;
  String? displayName;
  String password;

  RegisterDto({
    required this.username,
    this.displayName,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["username"] = username;
    json["displayName"] = displayName;
    json["password"] = password;
    return json;
  }
}
