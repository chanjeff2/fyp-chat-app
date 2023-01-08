import 'package:fyp_chat_app/entities/chatroom_entity.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/one_to_one_chat.dart';
import 'package:fyp_chat_app/storage/disk_storage.dart';
import 'package:fyp_chat_app/storage/group_member_store.dart';
import 'package:sqflite/sqflite.dart';

class ChatroomStore {
  // singleton
  ChatroomStore._();
  static final ChatroomStore _instance = ChatroomStore._();
  factory ChatroomStore() {
    return _instance;
  }

  static const table = 'chatroom';

  Future<bool> contains(String id) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      columns: ['COUNT(*)'],
      where: '${ChatroomEntity.columnId} = ?',
      whereArgs: [id],
    );
    return (Sqflite.firstIntValue(result) ?? 0) > 0;
  }

  Future<List<Chatroom>> getAllChatroom() async {
    final db = await DiskStorage().db;
    final result = await db.query(table);

    final chatroomList = await Future.wait(result
        .map((e) => ChatroomEntity.fromJson(e))
        .map((e) async => Chatroom.fromEntity(e)));
    return chatroomList.whereType<Chatroom>().toList();
  }

  Future<Chatroom?> get(String id) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${ChatroomEntity.columnId} = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) {
      return null;
    }
    final entity = ChatroomEntity.fromJson(result[0]);
    return await Chatroom.fromEntity(entity);
  }

  Future<bool> remove(String id) async {
    final db = await DiskStorage().db;
    final chatroom = await get(id);
    if (chatroom == null) {
      return false;
    }
    // clear group member
    await GroupMemberStore().removeByChatroomId(chatroom.id);
    // delete chatroom
    final count = await db.delete(
      table,
      where: '${ChatroomEntity.columnId} = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  Future<void> save(Chatroom chatroom) async {
    final db = await DiskStorage().db;
    late final ChatroomEntity entity;
    switch (chatroom.type) {
      case ChatroomType.oneToOne:
        entity = (chatroom as OneToOneChat).toEntity();
        break;
      case ChatroomType.group:
        entity = (chatroom as GroupChat).toEntity();
        // add group members
        await Future.wait(chatroom.members
            .map((e) async => await GroupMemberStore().save(chatroom.id, e)));
        break;
    }
    final map = entity.toJson();
    // try update
    final count = await db.update(
      table,
      map,
      where: '${ChatroomEntity.columnId} = ?',
      whereArgs: [entity.id],
    );
    // if no existing record, insert new record
    if (count == 0) await db.insert(table, map);
  }
}
