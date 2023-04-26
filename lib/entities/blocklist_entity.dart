import 'package:json_annotation/json_annotation.dart';

part 'blocklist_entity.g.dart';

@JsonSerializable()
class BlocklistEntity {
  static const String createTableCommandFields = """
$columnBlock TEXT PRIMARY KEY
""";

  static const columnBlock = "block";

  /// the user id of target user for [OneToOneChat], group id for [GroupChat]
  @JsonKey(required: true, name: columnBlock)
  final String block;

  BlocklistEntity({
    required this.block,
  });

  Map<String, dynamic> toJson() => _$BlocklistEntityToJson(this);

  factory BlocklistEntity.fromJson(Map<String, dynamic> json) =>
      _$BlocklistEntityFromJson(json);
}
