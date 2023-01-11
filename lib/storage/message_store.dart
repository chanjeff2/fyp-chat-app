import 'package:fyp_chat_app/entities/plain_message_entity.dart';
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
      where: '${PlainMessageEntity.columnChatroomId} = ?',
      whereArgs: [chatroomId],
      orderBy: '${PlainMessageEntity.columnSentAt} DESC',
      offset: start,
      limit: count,
    );
    return result.map((e) {
      final entity = PlainMessageEntity.fromJson(e);
      return PlainMessage.fromEntity(entity);
    }).toList();
  }

  Future<int> getNumberOfUnreadMessageByChatroomId(
    String chatroomId,
  ) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      columns: ['COUNT(*)'],
      where:
          '${PlainMessageEntity.columnChatroomId} = ? AND ${PlainMessageEntity.columnIsRead} = 0',
      whereArgs: [chatroomId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<bool> removeMessage(int messageId) async {
    final db = await DiskStorage().db;
    final count = await db.delete(
      table,
      where: '${PlainMessageEntity.columnId} = ?',
      whereArgs: [messageId],
    );
    return count > 0;
  }

  Future<bool> removeContact(int userId) async {
    final db = await DiskStorage().db;
    final count = await db.delete(
      table,
      where: '${PlainMessageEntity.columnSenderUserId} = ?',
      whereArgs: [userId],
    );
    return count > 0;
  }

  Future<int> storeMessage(PlainMessage message) async {
    final messageMap = message.toEntity().toJson();
    final db = await DiskStorage().db;
    final id = await db.insert(table, messageMap);
    return id;
  }

  Future<bool> readMessage(int messageId) async {
    final db = await DiskStorage().db;
    final count = await db.update(
      table,
      {PlainMessageEntity.columnIsRead: 1},
      where: '${PlainMessageEntity.columnId} = ?',
      whereArgs: [messageId],
    );
    return count > 0;
  }

  Future<bool> readAllMessageOfChatroom(String chatroomId) async {
    final db = await DiskStorage().db;
    final count = await db.update(
      table,
      {PlainMessageEntity.columnIsRead: 1},
      where:
          '${PlainMessageEntity.columnChatroomId} = ? AND ${PlainMessageEntity.columnIsRead} = 0',
      whereArgs: [chatroomId],
    );
    return count > 0;
  }
}
