import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

extension IdentityKeyPairExtension on IdentityKeyPair {
  String encodeToString() => base64.encode(serialize());
  static IdentityKeyPair decodeFromString(String encoded) =>
      IdentityKeyPair.fromSerialized(base64.decode(encoded));
}

extension IdentityKeyExtension on IdentityKey {
  String encodeToString() => base64.encode(serialize());
  static IdentityKey decodeFromString(String encoded) =>
      IdentityKey.fromBytes(base64.decode(encoded), 0);
}

extension ECPublicKeyExtension on ECPublicKey {
  String encodeToString() => base64.encode(serialize());
  static ECPublicKey decodeFromString(String encoded) =>
      Curve.decodePoint(base64.decode(encoded), 0);
}

extension PreKeyRecordExtension on PreKeyRecord {
  String encodeToString() => base64.encode(serialize());
  static PreKeyRecord decodeFromString(String encoded) =>
      PreKeyRecord.fromBuffer(base64.decode(encoded));
}

extension SignedPreKeyRecordExtension on SignedPreKeyRecord {
  String encodeToString() => base64.encode(serialize());
  static SignedPreKeyRecord decodeFromString(String encoded) =>
      SignedPreKeyRecord.fromSerialized(base64.decode(encoded));
}

extension PreKeySignalMessageExtension on PreKeySignalMessage {
  String encodeToString() => base64.encode(serialize());
  static PreKeySignalMessage decodeFromString(String encoded) =>
      PreKeySignalMessage(base64.decode(encoded));
}

extension SessionRecordExtension on SessionRecord {
  String encodeToString() => base64.encode(serialize());
  static SessionRecord decodeFromString(String encoded) =>
      SessionRecord.fromSerialized(base64.decode(encoded));
}

extension SignatureExtension on Uint8List {
  String encodeToString() => base64.encode(this);
  static Uint8List decodeFromString(String encoded) => base64.decode(encoded);
}
