import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/send_message_response_dto.dart';

void main() {
  late final SendMessageResponseDto sendMessageResponseDto;
  setUpAll(() {
    //setup
    sendMessageResponseDto = SendMessageResponseDto(
      misMatchDeviceIds: [1, 2, 3],
      missingDeviceIds: [4, 5, 6],
      removedDeviceIds: [7, 8, 9],
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = sendMessageResponseDto.toJson();
    //de-serialize
    final receivedSendMessageResponseDto =
        SendMessageResponseDto.fromJson(json);
    //compare
    expect(receivedSendMessageResponseDto.misMatchDeviceIds,
        sendMessageResponseDto.misMatchDeviceIds);
    expect(receivedSendMessageResponseDto.missingDeviceIds,
        sendMessageResponseDto.missingDeviceIds);
    expect(receivedSendMessageResponseDto.removedDeviceIds,
        sendMessageResponseDto.removedDeviceIds);
  });
}
