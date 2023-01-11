import 'package:json_annotation/json_annotation.dart';

part 'group_member_entity.g.dart';

@JsonSerializable()
class GroupMemberEntity {
  static const String createTableCommandFields = """
$columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
$columnChatroomId TEXT NOT NULL, 
$columnUserId TEXT NOT NULL
""";

  static const columnId = "id";
  @JsonKey(name: columnId, includeIfNull: false)
  int? id;

  static const columnChatroomId = "chatroomId";
  @JsonKey(required: true, name: columnChatroomId)
  final String chatroomId;

  static const columnUserId = "userId";
  @JsonKey(required: true, name: columnUserId)
  final String userId;

  GroupMemberEntity({
    this.id,
    required this.chatroomId,
    required this.userId,
  });

  Map<String, dynamic> toJson() => _$GroupMemberEntityToJson(this);

  factory GroupMemberEntity.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberEntityFromJson(json);
}
