import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/one_to_one_chat.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chatroom_entity.g.dart';

@JsonSerializable()
class ChatroomEntity {
  static const String createTableCommandFields = """
$columnId TEXT PRIMARY KEY NOT NULL, 
$columnType INTEGER NOT NULL,
$columnName TEXT,
$columnCreatedAt TEXT NOT NULL,
$columnGroupType INTEGER,
$columnDescription TEXT,
$columnProfilePicUrl TEXT
""";

  static const columnId = "id";

  /// the user id of target user for [OneToOneChat], group id for [GroupChat]
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

  static const columnCreatedAt = "createdAt";

  /// exist after created in db
  @JsonKey(required: true, name: columnCreatedAt)
  final String createdAt;

  static const columnGroupType = "groupType";
  @JsonKey(required: true, name: columnGroupType)
  final int? groupType;

  static const columnDescription = "description";
  @JsonKey(required: false, name: columnDescription)
  final String? description;

  static const columnProfilePicUrl = "profilePicUrl";
  @JsonKey(required: false, name: columnProfilePicUrl)
  final String? profilePicUrl;

  ChatroomEntity({
    required this.id,
    required this.type,
    this.name,
    required this.createdAt,
    this.groupType,
    this.description,
    this.profilePicUrl,
  });

  Map<String, dynamic> toJson() => _$ChatroomEntityToJson(this);

  factory ChatroomEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatroomEntityFromJson(json);
}

List<String> membersFromString(String? string) => string?.split(' ') ?? [];
String? membersToString(List<String>? members) => members?.join(' ');
