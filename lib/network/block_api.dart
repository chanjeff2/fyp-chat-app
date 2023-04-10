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
      return (json as List).cast<String>();
    } catch (e) {
      rethrow;
    }
  }

  //get whether the target user is in low score/warning status
  Future<bool> getWarningStatus(String targetuserId) async {
    try {
      final json = await get("/$targetuserId/trustworthy", useAuth: true);
      return json;
    } catch (e) {
      rethrow;
    }
  }
}
