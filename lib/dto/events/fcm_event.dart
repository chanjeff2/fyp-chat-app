import 'package:fyp_chat_app/models/enum.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class FCMEvent {
  @JsonKey(required: true)
  final FCMEventType type;

  FCMEvent(this.type);
}
