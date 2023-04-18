import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/account_dto.dart';
import 'package:fyp_chat_app/models/account.dart';

void main() {
  late final Account account;
  setUpAll(() async {
    // setup an account
    account = Account(
      userId: "id",
      username: "username",
      displayName: 'displayName',
      status: 'status',
    );
  });
  test('serialize and de-serialize to DTO', () async {
    // serialize
    final dto = account.toDto();
    // de-serialize
    final receivedAccount = Account.fromDto(dto);
    // compare
    expect(receivedAccount.userId, account.userId);
    expect(receivedAccount.username, account.username);
    expect(receivedAccount.displayName, account.displayName);
    expect(receivedAccount.status, account.status);
  });

  test('serialize and de-serialize DTO to JSON', () async {
    final dto = account.toDto();
    // serialize
    final json = dto.toJson();
    // de-serialize
    final receivedDto = AccountDto.fromJson(json);
    // compare
    expect(receivedDto.userId, dto.userId);
    expect(receivedDto.username, dto.username);
    expect(receivedDto.displayName, dto.displayName);
    expect(receivedDto.status, dto.status);
  });
}
