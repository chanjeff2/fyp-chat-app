import 'dart:collection';
import 'package:collection/collection.dart';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';


class DiskIdentityKeyStore extends IdentityKeyStore {
  // singleton
  DiskIdentityKeyStore._();
  static final DiskIdentityKeyStore _instance = DiskIdentityKeyStore._();
  factory DiskIdentityKeyStore(IdentityKeyPair identityKeyPair, int localRegistrationId) {
    _instance.identityKeyPair = identityKeyPair;
    _instance.localRegistrationId = localRegistrationId;
    return _instance;
  }

  final trustedKeys = HashMap<SignalProtocolAddress, IdentityKey>();

  late final IdentityKeyPair identityKeyPair;
  late final int localRegistrationId;

  @override
  Future<IdentityKey?> getIdentity(SignalProtocolAddress address) async {
    // TODO: implement getIdentity
    return trustedKeys[address]!;
    // throw UnimplementedError();
  }

  @override
  Future<IdentityKeyPair> getIdentityKeyPair() async {
    // TODO: implement getIdentityKeyPair
    return identityKeyPair;
    // throw UnimplementedError();
  }

  @override
  Future<int> getLocalRegistrationId() async {
    // TODO: implement getLocalRegistrationId
    return localRegistrationId;
    // throw UnimplementedError();
  }

  @override
  Future<bool> isTrustedIdentity(SignalProtocolAddress address,
      IdentityKey? identityKey, Direction direction) async {
    // TODO: implement isTrustedIdentity
    final trusted = trustedKeys[address];
    if (identityKey == null || trusted == null) {
      return false;
    }
    return const ListEquality().equals(trusted.serialize(), identityKey.serialize());
    // throw UnimplementedError();
  }

  @override
  Future<bool> saveIdentity(
      SignalProtocolAddress address, IdentityKey? identityKey) async {
    // TODO: implement saveIdentity
    final existing = trustedKeys[address];
    if (identityKey == null) {
      return false;
    }
    if (identityKey != existing) {
      trustedKeys[address] = identityKey;
      return true;
    } else {
      return false;
    }
    // throw UnimplementedError();
  }
}
