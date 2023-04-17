import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

part 'pre_key_pair_entity.g.dart';

@JsonSerializable()
class PreKeyPairEntity {
  static const String createTableCommandFields = """
$columnId INTEGER PRIMARY KEY, 
$columnKeyPair TEXT NOT NULL
""";

  static const columnId = "id";
  @JsonKey(required: true, name: columnId)
  final int id;

  static const columnKeyPair = "keyPair";
  @JsonKey(required: true, name: columnKeyPair)
  final String keyPair;

  PreKeyPairEntity(this.id, this.keyPair);

  Map<String, dynamic> toJson() => _$PreKeyPairEntityToJson(this);

  factory PreKeyPairEntity.fromJson(Map<String, dynamic> json) =>
      _$PreKeyPairEntityFromJson(json);

  PreKeyPairEntity.fromPreKeyRecord(PreKeyRecord record)
      : id = record.id,
        keyPair = record.encodeToString();

  PreKeyRecord toPreKeyRecord() {
    return PreKeyRecordExtension.decodeFromString(keyPair);
  }
}
