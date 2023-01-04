import 'package:fyp_chat_app/dto/pre_key_dto.dart';
import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class PreKey {
  final int id;
  final ECPublicKey key;

  PreKey(this.id, this.key);

  PreKey.fromDto(PreKeyDto dto)
      : id = dto.id,
        key = ECPublicKeyExtension.decodeFromString(dto.key);

  PreKey.fromPreKeyRecord(PreKeyRecord record)
      : id = record.id,
        key = record.getKeyPair().publicKey;

  PreKey.fromSignedPreKeyRecord(SignedPreKeyRecord record)
      : id = record.id,
        key = record.getKeyPair().publicKey;

  PreKeyDto toDto() {
    return PreKeyDto(
      id,
      key.encodeToString(),
    );
  }
}
