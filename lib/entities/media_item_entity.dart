import 'package:json_annotation/json_annotation.dart';

part 'media_item_entity.g.dart';

@JsonSerializable()
class MediaItemEntity {
   static const String createTableCommandFields = """
$columnId TEXT PRIMARY KEY NOT NULL,
$columnContent BLOB NOT NULL, 
$columnExtension TEXT NOT NULL,
$columnType INTEGER NOT NULL
""";

  static const columnId = "id";
  @JsonKey(required: true)
  String id;

  static const columnContent = "content";
  @JsonKey(required: true)
  final List<int> content;

  static const columnExtension = "extension";
  @JsonKey(required: true)
  final String ext;

  
  static const columnType = "type";
  @JsonKey(required: true)
  final int type;

  MediaItemEntity({
    required this.id,
    required this.content,
    required this.ext,
    required this.type,
  });

  Map<String, dynamic> toJson() => _$MediaItemEntityToJson(this);

  factory MediaItemEntity.fromJson(Map<String, dynamic> json) =>
      _$MediaItemEntityFromJson(json);
}