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
      profilePicUrl:
          "https://storage.googleapis.com/download/storage/test-link-doesnt-link-to-anything",
      updatedAt: DateTime.now(),
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
    expect(receivedAccount.profilePicUrl, account.profilePicUrl);
    expect(receivedAccount.updatedAt, account.updatedAt);
  });
}
