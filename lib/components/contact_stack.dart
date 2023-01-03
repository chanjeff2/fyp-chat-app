import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/contact_option.dart';
import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/models/user.dart';
import 'package:fyp_chat_app/storage/contact_store.dart';
import 'package:fyp_chat_app/storage/message_store.dart';

class ContactStack extends StatefulWidget {
  const ContactStack({Key? key}) : super(key: key);

  @override
  State<ContactStack> createState() => _ContactStackState();
}

class _ContactStackState extends State<ContactStack> {
  final List<HomeContact> _contacts = [];

  @override
  initState() async {
    super.initState();
    List<User>? contacts = await ContactStore().getAllContact();
    if (contacts != null) {
      for (var contact in contacts) {
        // Get all unread messages, get latest message and unread
        // We may need to further filter the messages by group after implementing group
        List<PlainMessage> messages = await MessageStore().getMessageByUserId(contact.userId);
        PlainMessage latestMessage = messages.reduce((currMsg, nextMsg) => currMsg.sentAt.isAfter(nextMsg.sentAt) ? currMsg : nextMsg);
        int unreadMessagesCount = messages.where((message) => (message.senderUserId == contact.userId) && !message.isRead).length;
        // Insert contact
        String name = contact.displayName ?? contact.name;
        setState(() {
          _contacts.insert(0, HomeContact(contactInfo: contact, latestMessage: latestMessage, notifications: unreadMessagesCount));
        });
      }
    }
  }

  bool hasContacts() { return _contacts.isEmpty; }

  // Insert the contact at the top of list
  void insert(HomeContact contact) {
    setState(() {
      _contacts.insert(0, contact);
    });
  }

  // Update the contact and push it to the top. If not exist, insert it
  void update(HomeContact contact) {
    final target = _contacts.where((session) => session.key == contact.key);
    if (target.isNotEmpty) {
      setState(() {
        // Remove the old contact from the list
        _contacts.remove(target.first);
      });
    }
    // Add it back to the beginning of the list => put it at the top
    setState(() {
      _contacts.insert(0, contact);
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) => _contacts[index],
      )
    );
  }
}