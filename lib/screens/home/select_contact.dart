import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/default_option.dart';
import 'package:fyp_chat_app/components/contact_option.dart';
import 'package:fyp_chat_app/models/user.dart';
import 'package:fyp_chat_app/network/api.dart';
import 'package:fyp_chat_app/network/users_api.dart';

import '../../storage/contact_store.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({
    Key? key,
    this.onNewContact,
  }) : super(key: key);
  final void Function(User)? onNewContact;

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  final List<Contact> _contacts = [

  ];

  String addContactInput = "";

  late TextEditingController addContactController;

  @override
  void initState() {
    // Add default items to list

    super.initState();

    addContactController = TextEditingController();
  }

  //dispose the add contact controller
  @override
  void dispose() {
    addContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Contact"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ListView.builder(
              itemCount: _contacts.length + 3,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return InkWell(
                      onTap: () {
                        /*
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => CreateGroup()));
                  */
                      },
                      child: const DefaultOption(
                        icon: Icons.group_add,
                        name: "Add group",
                      ),
                    );

                  case 1:
                    return InkWell(
                      onTap: () async {
                        //Pop up screen for add content
                        final name = await addContactDialog();
                        if (name == null || name.isEmpty) return;
                        setState(() {
                          addContactInput = name;
                        });
                        //add the user to local storage contact
                        try {
                          User addUser = User.fromDto(await UsersApi()
                              .getUserByUsername(addContactInput));
                          //local storage on disk
                          ContactStore().storeContact(addUser);
                          // callback and return to home
                          Navigator.of(context).pop();
                          widget.onNewContact?.call(addUser);
                          //print(_contacts.length);
                        } on ApiException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("error: ${e.message}")));
                        }
                      },
                      child: const DefaultOption(
                        icon: Icons.person_add,
                        name: "Add contact",
                      ),
                    );

                  case 2:
                    return const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Text(
                        "Groups in USTalk",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );

                  default:
                    return ContactOption();
                }
              }),
        ));
  }

  Future<String?> addContactDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Add Contact'),
          content: TextField(
            autofocus: true,
            decoration:
                const InputDecoration(hintText: "Please enter the username"),
            controller: addContactController,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(addContactController.text);
                  addContactController.clear();
                },
                child: const Text('Submit'))
          ],
        ),
      );
}

// modal class for Contact, can remove later
class Contact {
  String username, /*status,*/ id;
  //Image img;
  Contact({
    required this.username,
    //required this.status,
    required this.id,
    //required this.img
  });
}
