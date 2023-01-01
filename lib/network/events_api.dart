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

  Future<void> sendMessage(SendMessageDto dto) async {
    await post("/message", body: dto.toJson(), useAuth: true);
  }
}
