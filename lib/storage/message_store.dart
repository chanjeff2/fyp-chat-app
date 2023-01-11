import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/storage/disk_storage.dart';
import 'package:sqflite/sqflite.dart';

class MessageStore {
  // singleton
  MessageStore._();
  static final MessageStore _instance = MessageStore._();
  factory MessageStore() {
    return _instance;
  }

  static const table = 'message';

  Future<List<PlainMessage>> getMessageByChatroomId(
    String chatroomId, {
    int start = 0,
    int count = 100,
  }) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${PlainMessage.columnChatroomId} = ?',
      whereArgs: [chatroomId],
      orderBy: '${PlainMessage.columnSentAt} DESC',
      offset: start,
      limit: count,
    );
    return result.map((e) => PlainMessage.fromJson(e)).toList();
  }

  Future<int> getNumberOfUnreadMessageByChatroomId(
    String chatroomId,
  ) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      columns: ['COUNT(*)'],
      where:
          '${PlainMessage.columnChatroomId} = ? AND ${PlainMessage.columnIsRead} = 0',
      whereArgs: [chatroomId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
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

  Future<bool> readMessage(int messageId) async {
    final db = await DiskStorage().db;
    final count = await db.update(
      table,
      {PlainMessage.columnIsRead: 1},
      where: '${PlainMessage.columnId} = ?',
      whereArgs: [messageId],
    );
    return count > 0;
  }

  Future<bool> readAllMessageOfChatroom(String chatroomId) async {
    final db = await DiskStorage().db;
    final count = await db.update(
      table,
      {PlainMessage.columnIsRead: 1},
      where:
          '${PlainMessage.columnChatroomId} = ? AND ${PlainMessage.columnIsRead} = 0',
      whereArgs: [chatroomId],
    );
    return count > 0;
  }
}
