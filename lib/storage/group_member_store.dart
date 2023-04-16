import 'package:fyp_chat_app/entities/group_member_entity.dart';
import 'package:fyp_chat_app/models/group_member.dart';
import 'package:fyp_chat_app/storage/contact_store.dart';
import 'package:fyp_chat_app/storage/disk_storage.dart';

class GroupMemberStore {
  // singleton
  GroupMemberStore._();
  static final GroupMemberStore _instance = GroupMemberStore._();
  factory GroupMemberStore() {
    return _instance;
  }

  static const table = 'groupMember';

  Future<List<GroupMember>> getByChatroomId(String chatroomId) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${GroupMemberEntity.columnChatroomId} = ?',
      whereArgs: [chatroomId],
    );
    final members = await Future.wait(
      result.map((e) => GroupMemberEntity.fromJson(e)).map((e) async {
        final user = await ContactStore().getContactById(e.userId);
        if (user == null) {
          return null;
        }
        return GroupMember(id: e.id, user: user, role: e.role);
      }),
    );
    return members.whereType<GroupMember>().toList();
  }

  Future<GroupMember?> get(int id) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${GroupMemberEntity.columnId} = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) {
      return null;
    }
    final entity = GroupMemberEntity.fromJson(result[0]);
    final user = await ContactStore().getContactById(entity.userId);
    if (user == null) {
      return null;
    }
    return GroupMember(id: entity.id, user: user, role: entity.role);
  }

  Future<GroupMember?> getbyChatroomIdAndUserId(
      String chatroomId, String userId) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where:
          '${GroupMemberEntity.columnChatroomId} = ? AND ${GroupMemberEntity.columnUserId} = ?',
      whereArgs: [chatroomId, userId],
    );
    if (result.isEmpty) {
      return null;
    }
    final entity = GroupMemberEntity.fromJson(result[0]);
    final user = await ContactStore().getContactById(entity.userId);
    if (user == null) {
      return null;
    }
    return GroupMember(id: entity.id, user: user, role: entity.role);
  }

  Future<bool> remove(String chatroomId, String userId) async {
    final db = await DiskStorage().db;
    final count = await db.delete(
      table,
      where:
          '${GroupMemberEntity.columnChatroomId} = ? AND ${GroupMemberEntity.columnUserId} = ?',
      whereArgs: [chatroomId, userId],
    );
    return count > 0;
  }

  Future<bool> removeById(String id) async {
    final db = await DiskStorage().db;
    final count = await db.delete(
      table,
      where: '${GroupMemberEntity.columnId} = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  Future<bool> removeByChatroomId(String chatroomId) async {
    final db = await DiskStorage().db;
    final count = await db.delete(
      table,
      where: '${GroupMemberEntity.columnChatroomId} = ?',
      whereArgs: [chatroomId],
    );
    return count > 0;
  }

  Future<void> save(String chatroomId, GroupMember member) async {
    final entity = GroupMemberEntity(
      id: member.id,
      chatroomId: chatroomId,
      userId: member.user.userId,
      role: member.role,
    );
    final map = entity.toJson();
    final db = await DiskStorage().db;
    if (member.id != null) {
      // update
      await db.update(
        table,
        map,
        where: '${GroupMemberEntity.columnId} = ?',
        whereArgs: [member.id],
      );
    } else {
      // insert new record
      await db.insert(table, map);
    }
  }
}
