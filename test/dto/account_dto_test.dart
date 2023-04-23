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
      displayName: "User123",
      status: "I'm the storm that is approaching",
      profilePicUrl:
          "https://storage.googleapis.com/download/storage/test-link-doesnt-link-to-anything",
      updatedAt: DateTime.now(),
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
    expect(receivedAccountDto.profilePicUrl, accountDto.profilePicUrl);
    expect(receivedAccountDto.updatedAt, accountDto.updatedAt);
  });
}
