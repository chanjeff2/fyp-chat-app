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
  Future<bool> sendBlockRequest(String chatroomId) async {
    try {
      await post("/block/$chatroomId", useAuth: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  //send Unblock request
  Future<bool> sendUnblockRequest(String chatroomId) async {
    try {
      await post("/unblock/$chatroomId", useAuth: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  //send Unblock request
  Future<List<String>> getBlockedListRequest(String userId) async {
    //userid is the user who ask for the block list
    try {
      final json = await get("/blocklist/$userId", useAuth: true);
      return json.map((e) => e).toList();
    } catch (e) {
      rethrow;
    }
  }
}
