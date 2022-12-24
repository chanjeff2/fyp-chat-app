import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class DiskSessionStore extends SessionStore {
  // singleton
  DiskSessionStore._();
  static final DiskSessionStore _instance = DiskSessionStore._();
  factory DiskSessionStore() {
    return _instance;
  }

  @override
  Future<bool> containsSession(SignalProtocolAddress address) {
    // TODO: implement containsSession
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAllSessions(String name) {
    // TODO: implement deleteAllSessions
    throw UnimplementedError();
  }

  @override
  Future<void> deleteSession(SignalProtocolAddress address) {
    // TODO: implement deleteSession
    throw UnimplementedError();
  }

  @override
  Future<List<int>> getSubDeviceSessions(String name) {
    // TODO: implement getSubDeviceSessions
    throw UnimplementedError();
  }

  @override
  Future<SessionRecord> loadSession(SignalProtocolAddress address) {
    // TODO: implement loadSession
    throw UnimplementedError();
  }

  @override
  Future<void> storeSession(
      SignalProtocolAddress address, SessionRecord record) {
    // TODO: implement storeSession
    throw UnimplementedError();
  }
}
