import 'package:fyp_chat_app/entities/chat_message_entity.dart';
import 'package:fyp_chat_app/models/chat_message.dart';
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

  Future<List<ChatMessage>> getMessageByChatroomId(
    String chatroomId, {
    int start = 0,
    int count = 100,
  }) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${ChatMessageEntity.columnChatroomId} = ?',
      whereArgs: [chatroomId],
      orderBy: '${ChatMessageEntity.columnSentAt} DESC',
      offset: start,
      limit: count,
    );
    final messages = await Future.wait(result
        .map((e) => ChatMessageEntity.fromJson(e))
        .map((e) async => ChatMessage.fromEntity(e)));
    return messages.whereType<ChatMessage>().toList();
  }

  Future<int> getNumberOfUnreadMessageByChatroomId(
    String chatroomId,
  ) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      columns: ['COUNT(*)'],
      where:
          '${ChatMessageEntity.columnChatroomId} = ? AND ${ChatMessageEntity.columnIsRead} = 0',
      whereArgs: [chatroomId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<bool> removeMessage(int messageId) async {
    final db = await DiskStorage().db;
    final count = await db.delete(
      table,
      where: '${ChatMessageEntity.columnId} = ?',
      whereArgs: [messageId],
    );
    return count > 0;
  }

  Future<bool> removeAllMessageByChatroomId(String chatroomId) async {
    final db = await DiskStorage().db;
    final count = await db.delete(
      table,
      where: '${ChatMessageEntity.columnChatroomId} = ?',
      whereArgs: [chatroomId],
    );
    return count > 0;
  }

  Future<bool> removeContact(int userId) async {
    final db = await DiskStorage().db;
    final count = await db.delete(
      table,
      where: '${ChatMessageEntity.columnSenderUserId} = ?',
      whereArgs: [userId],
    );
    return count > 0;
  }

  Future<int> storeMessage(ChatMessage message) async {
    final messageMap = message.toEntity().toJson();
    final db = await DiskStorage().db;
    final id = await db.insert(table, messageMap);
    return id;
  }

  Future<bool> readMessage(int messageId) async {
    final db = await DiskStorage().db;
    final count = await db.update(
      table,
      {ChatMessageEntity.columnIsRead: 1},
      where: '${ChatMessageEntity.columnId} = ?',
      whereArgs: [messageId],
    );
    return count > 0;
  }

  Future<bool> readAllMessageOfChatroom(String chatroomId) async {
    final db = await DiskStorage().db;
    final count = await db.update(
      table,
      {ChatMessageEntity.columnIsRead: 1},
      where:
          '${ChatMessageEntity.columnChatroomId} = ? AND ${ChatMessageEntity.columnIsRead} = 0',
      whereArgs: [chatroomId],
    );
    return count > 0;
  }
}
