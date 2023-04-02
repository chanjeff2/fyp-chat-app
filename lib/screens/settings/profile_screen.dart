import 'package:flutter/material.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/network/api.dart';
import 'package:provider/provider.dart';

import '../../network/account_api.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController textController;

  @override
  void initState() {
    // Add default items to list

    super.initState();

    textController = TextEditingController();
  }

  //dispose the add contact controller
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
        builder: (context, userState, child) => Scaffold(
              appBar: AppBar(
                title: const Text("Profile"),
              ),
              body: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        const CircleAvatar(
                          radius: 72,
                          // child: profilePicture ? null : Icon(Icons.person, size: 48),
                          // backgroundImage: profileImage,
                          child:
                              Icon(Icons.person, size: 72, color: Colors.white),
                          backgroundColor: Colors.blueGrey,
                        ),
                        Positioned(
                          bottom: 1,
                          right: 1,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              child: const Padding(
                                padding: EdgeInsets.all(2.0),
                                child:
                                    Icon(Icons.camera_alt, color: Colors.black),
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 6,
                                    color: Colors.white,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(2, 4),
                                      color: Colors.black.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 3,
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Display name
                  InkWell(
                      onTap: () async {
                        String? name = await inputDialog(
                          "Display Name",
                          "Please enter your Display Name(Enter nothing input your username by default)",
                        );
                        if (name == null || name.isEmpty) {
                          name = userState.me!.username;
                        }
                        //send post request to server to update display name
                        String? tempDisplayName = userState.me!.displayName;
                        userState.me!.displayName = name;
                        try {
                          await AccountApi().updateAccount(userState.me!);
                        } catch (e) {
                          userState.me!.displayName = tempDisplayName;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          );
                        }
                      },
                      child: ListTile(
                        leading: const SizedBox(
                          height: double.infinity,
                          child:
                              Icon(Icons.person, color: Colors.black, size: 30),
                        ),
                        title: const Text(
                          "Display Name",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        subtitle: Text(
                          userState.me!.displayName ?? userState.me!.username,
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: Icon(Icons.edit,
                            color: Theme.of(context).primaryColor),
                      )),
                  const Divider(thickness: 2, indent: 62),
                  // Status
                  InkWell(
                      onTap: () async {
                        String? status = await inputDialog(
                          "Status",
                          "Please enter your Status(Enter nothing input default status)",
                        );
                        if (status == null || status.isEmpty) {
                          status = "Hi! I'm using USTalk.";
                        }
                        //send post request to server to update display name
                        String? tempStatus = userState.me!.status;
                        userState.me!.status = status;
                        try {
                          await AccountApi().updateAccount(userState.me!);
                        } catch (e) {
                          userState.me!.status = tempStatus;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          );
                        }
                      },
                      child: ListTile(
                        leading: const SizedBox(
                          height: double.infinity,
                          child: Icon(Icons.info_outline,
                              color: Colors.black, size: 30),
                        ),
                        title: const Text(
                          "Status",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        subtitle: Text(
                          userState.me!.status.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: Icon(Icons.edit,
                            color: Theme.of(context).primaryColor),
                      )),
                ],
              ),
            ));
  }

  Future<String?> inputDialog(String title, String hint) => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: hint),
            controller: textController,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(textController.text);
                  textController.clear();
                },
                child: const Text('Submit'))
          ],
        ),
      );
}
