import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/register_dto.dart';

void main() {
  late final RegisterDto registerDto;
  setUpAll(() {
    //setup
    registerDto = RegisterDto(
      username: 'name',
      displayName: 'displayName',
      password: 'password',
    );
  });
  test('serialize to json', () async {
    //serialize
    final json = registerDto.toJson();
    //compare
    expect(json['username'], registerDto.username);
    expect(json['displayName'], registerDto.displayName);
    expect(json['password'], registerDto.password);
  });
}
