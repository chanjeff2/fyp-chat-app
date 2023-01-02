import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/storage/disk_storage.dart';

class MessageStore {
  // singleton
  MessageStore._();
  static final MessageStore _instance = MessageStore._();
  factory MessageStore() {
    return _instance;
  }

  static const table = 'message';

  Future<List<PlainMessage>> getMessageBySenderUserId(String userId) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${PlainMessage.columnSenderUserId} = ?',
      whereArgs: [userId],
    );
    return result.map((e) => PlainMessage.fromJson(e)).toList();
  }

  Future<List<PlainMessage>> getMessageBySenderUsername(String username) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${PlainMessage.columnSenderUsername} = ?',
      whereArgs: [username],
    );
    return result.map((e) => PlainMessage.fromJson(e)).toList();
  }

  Future<bool> removeMessage(int messageId) async {
    final db = await DiskStorage().db;
    final count = await db.delete(
      table,
      where: '${PlainMessage.columnId} = ?',
      whereArgs: [messageId],
    );
    return count > 0;
  }

  Future<bool> removeContact(int userId) async {
    final db = await DiskStorage().db;
    final count = await db.delete(
      table,
      where: '${PlainMessage.columnSenderUserId} = ?',
      whereArgs: [userId],
    );
    return count > 0;
  }

  Future<int> storeMessage(PlainMessage message) async {
    final messageMap = message.toJson();
    final db = await DiskStorage().db;
    final id = await db.insert(table, messageMap);
    return id;
  }
}
