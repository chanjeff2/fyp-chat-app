import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/default_option.dart';
import 'package:fyp_chat_app/components/contact_option.dart';
import 'package:fyp_chat_app/models/user.dart';
import 'package:fyp_chat_app/network/api.dart';
import 'package:fyp_chat_app/network/users_api.dart';
import 'package:fyp_chat_app/screens/register_or_login/loading_screen.dart';

import '../../storage/contact_store.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({Key? key}) : super(key: key);

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
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

  Future<List<User>> getAllContact() async {
    Future<List<User>> futureList = ContactStore().getAllContact();
    List<User> user = await futureList;
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Contact"),
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: FutureBuilder<List<User>>(
              future: getAllContact(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<User> _localStorageContact = snapshot.data!;
                  return ListView.builder(
                      itemCount: _localStorageContact.length + 3,
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            {
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
                            }
                          case 1:
                            {
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
                                    setState(() {
                                      //local storage on disk
                                      ContactStore().storeContact(addUser);
                                    });
                                  } on ApiException catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("error: ${e.message}")));
                                  }
                                },
                                child: const DefaultOption(
                                  icon: Icons.person_add,
                                  name: "Add contact",
                                ),
                              );
                            }
                          case 2:
                            {
                              return const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Text(
                                  "Contacts on USTalk",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            }
                          default:
                            {
                              return ContactOption(
                                  user: _localStorageContact[index - 3]);
                            }
                        }
                      });
                } else {
                  return const LoadingScreen();
                }
              },
            )));
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
