import 'package:fyp_chat_app/dto/send_message_response_dto.dart';

import '../dto/send_message_dto.dart';
import 'api.dart';

class BlockApi extends Api {
  // singleton
  BlockApi._();
  static final BlockApi _instance = BlockApi._();
  factory BlockApi() {
    return _instance;
  }

  @override
  String pathPrefix = "/block";

  //send block request
  Future<bool> sendBlockRequest(String chatroomId) async {
    try {
      await post("/$chatroomId", useAuth: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  //send Unblock request
  Future<bool> sendUnblockRequest(String chatroomId) async {
    try {
      await delete("/$chatroomId", useAuth: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  //send Unblock request
  Future<List<String>> getBlockedListRequest() async {
    //userid is the user who ask for the block list
    try {
      final json = await get("", useAuth: true);
      return json.map((e) => (e as String)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
