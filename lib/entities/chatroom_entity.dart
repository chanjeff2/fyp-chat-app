import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/one_to_one_chat.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chatroom_entity.g.dart';

@JsonSerializable()
class ChatroomEntity {
  static const String createTableCommandFields = """
$columnId TEXT PRIMARY KEY NOT NULL, 
$columnType INTEGER NOT NULL
""";

  static const columnId = "id";

  /// the user id of target user for [OneToOneChat], a random uuid for [GroupChat]
  @JsonKey(required: true, name: columnId)
  final String id;

  static const columnType = "type";

  /// [ChatroomType].index
  @JsonKey(required: true, name: columnType)
  final int type;

  static const columnName = "name";

  /// required for [GroupChat] only
  @JsonKey(required: true, name: columnName)
  final String? name;

  ChatroomEntity({
    required this.id,
    required this.type,
    this.name,
  });

  Map<String, dynamic> toJson() => _$ChatroomEntityToJson(this);

  factory ChatroomEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatroomEntityFromJson(json);
}

List<String> membersFromString(String? string) => string?.split(' ') ?? [];
String? membersToString(List<String>? members) => members?.join(' ');
