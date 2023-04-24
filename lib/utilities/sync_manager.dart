import 'package:fyp_chat_app/dto/sync_group_dto.dart';
import 'package:fyp_chat_app/dto/sync_user_dto.dart';
import 'package:fyp_chat_app/network/group_chat_api.dart';
import 'package:fyp_chat_app/network/users_api.dart';
import 'package:fyp_chat_app/storage/chatroom_store.dart';
import 'package:fyp_chat_app/storage/contact_store.dart';

class SyncManager {
  Future<void> synchronizeContacts() async {
    final contacts = await ContactStore().getAll();
    final contactsNeedUpdate = await UsersApi().synchronize(contacts
        .map((e) => SyncUserDto(id: e.userId, updatedAt: e.updatedAt))
        .toList());
    await Future.wait(contactsNeedUpdate
        .map((contact) async => await ContactStore().storeContact(contact)));
  }

  Future<void> synchronizeGroups() async {
    final groups = await ChatroomStore().getAllGroupChatEntity();
    final groupsNeedUpdate = await GroupChatApi().synchronize(groups
        .map((e) =>
            SyncGroupDto(id: e.id, updatedAt: e.updatedAt ?? e.createdAt))
        .toList());
    await Future.wait(groupsNeedUpdate
        .map((e) async => await ChatroomStore().updateGroupInfo(e)));
  }
}
