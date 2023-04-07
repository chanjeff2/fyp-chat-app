import 'package:fyp_chat_app/models/user.dart';

import '../dto/account_dto.dart';

class Account extends User {
  Account({
    required String userId,
    required String username,
    String? displayName,
    String? status,
  }) : super(
          userId: userId,
          username: username,
          displayName: displayName,
          status: status,
        );

  Account.fromDto(AccountDto dto)
      : super(
          userId: dto.userId,
          username: dto.username,
          displayName: dto.displayName,
          status: dto.status,
        );

  AccountDto toDto() => AccountDto(
        userId: userId,
        username: username,
        displayName: displayName,
        status: status,
      );
}
