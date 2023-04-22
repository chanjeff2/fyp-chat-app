import 'package:fyp_chat_app/dto/sync_user_dto.dart';
import 'package:fyp_chat_app/network/users_api.dart';
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
}
