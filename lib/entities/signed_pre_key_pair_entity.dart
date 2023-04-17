import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

part 'signed_pre_key_pair_entity.g.dart';

@JsonSerializable()
class SignedPreKeyPairEntity {
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

  SignedPreKeyPairEntity(this.id, this.keyPair);

  Map<String, dynamic> toJson() => _$SignedPreKeyPairEntityToJson(this);

  factory SignedPreKeyPairEntity.fromJson(Map<String, dynamic> json) =>
      _$SignedPreKeyPairEntityFromJson(json);

  SignedPreKeyPairEntity.fromSignedPreKeyRecord(SignedPreKeyRecord record)
      : id = record.id,
        keyPair = record.encodeToString();

  SignedPreKeyRecord toSignedPreKeyRecord() {
    return SignedPreKeyRecordExtension.decodeFromString(keyPair);
  }
}
