import 'package:fyp_chat_app/dto/send_message_response_dto.dart';

import '../dto/send_message_dto.dart';
import 'api.dart';

class EventsApi extends Api {
  // singleton
  EventsApi._();
  static final EventsApi _instance = EventsApi._();
  factory EventsApi() {
    return _instance;
  }

  @override
  String pathPrefix = "/events";

  Future<SendMessageResponseDto> sendMessage(SendMessageDto dto) async {
    final json = await post("/message", body: dto.toJson(), useAuth: true);
    return SendMessageResponseDto.fromJson(json);
  }

  //send block request
  Future<bool> sendBlockRequest(String userId, String chatroomId) async {
    try {
      await post("/block/$userId/$chatroomId", useAuth: true);
      return true;
    } catch (e) {
      return false;
    }
  }
}
