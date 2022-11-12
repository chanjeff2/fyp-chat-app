class AccountDto {
  String userId;
  String username;
  String? displayName;

  AccountDto({
    required this.userId,
    required this.username,
    this.displayName,
  });

  AccountDto.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        username = json['username'],
        displayName = json['displayName'];
}
