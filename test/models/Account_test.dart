import 'package:flutter_test/flutter_test.dart';
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
  test('serialize and de-serialize', () async {
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
}
