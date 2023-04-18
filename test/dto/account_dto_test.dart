import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/account_dto.dart';
import 'package:fyp_chat_app/models/account.dart';

void main() {
  late final AccountDto accountDto;
  setUpAll(() async {
    // setup a test account
    accountDto = Account(
      userId: "1234",
      username: "testuser",
    ).toDto();
  });
  test('serialize and de-serialize json', () async {
    // serialize
    final json = accountDto.toJson();
    // de-serialize
    final receivedAccountDto = AccountDto.fromJson(json);
    // compare
    expect(receivedAccountDto.userId, accountDto.userId);
    expect(receivedAccountDto.username, accountDto.username);
    expect(receivedAccountDto.displayName, accountDto.displayName);
    expect(receivedAccountDto.status, accountDto.status);
  });
}