import 'dart:convert';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class IdentityKeyPairDb {
  final String buffer;

  IdentityKeyPairDb(this.buffer);

  IdentityKeyPairDb.fromIdentityKeyPair(IdentityKeyPair identityKeyPair)
      : buffer = base64.encode(identityKeyPair.serialize());

  IdentityKeyPair toIdentityKeyPair() {
    return IdentityKeyPair.fromSerialized(base64.decode(buffer));
  }
}

class PreKeyRecordDb {
  final String buffer;

  PreKeyRecordDb(this.buffer);

  PreKeyRecordDb.fromPreKeyRecord(PreKeyRecord record)
      : buffer = base64.encode(record.serialize());

  PreKeyRecord toPreKeyRecord() {
    return PreKeyRecord.fromBuffer(base64.decode(buffer));
  }
}

class SignedPreKeyRecordDb {
  final String buffer;

  SignedPreKeyRecordDb(this.buffer);

  SignedPreKeyRecordDb.fromSignedPreKeyRecord(SignedPreKeyRecord record)
      : buffer = base64.encode(record.serialize());

  SignedPreKeyRecord toPreKeyRecord() {
    return SignedPreKeyRecord.fromSerialized(base64.decode(buffer));
  }
}
