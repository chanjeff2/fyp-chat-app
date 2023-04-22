import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/user_icon.dart';
import 'package:fyp_chat_app/models/account.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:provider/provider.dart';

import '../../network/account_api.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController statusController;
  late TextEditingController displayNameController;

  @override
  void initState() {
    // Add default items to list

    super.initState();

    statusController = TextEditingController();
    displayNameController = TextEditingController();
  }

  //dispose the add contact controller
  @override
  void dispose() {
    statusController.dispose();
    displayNameController.dispose();
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
                        UserIcon(
                          radius: 72,
                          iconSize: 72,
                          isGroup: false,
                          profilePicUrl: userState.me!.profilePicUrl,
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
                  // User name
                  InkWell(
                      child: ListTile(
                    leading: const SizedBox(
                      height: double.infinity,
                      child: Icon(Icons.person, color: Colors.black, size: 30),
                    ),
                    title: const Text(
                      "User Name",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    subtitle: Text(
                      userState.me!.username,
                      style: const TextStyle(fontSize: 18),
                    ),
                  )),
                  const Divider(thickness: 2, indent: 62),
                  // Display name
                  InkWell(
                      onTap: () async {
                        String? name = await inputDialog(
                          "Display Name",
                          "Please enter your Display Name(Enter nothing input your username by default)",
                          displayNameController,
                        );
                        try {
                          if (name == null || name.isEmpty) {
                            return;
                          }
                          //send post request to server to update display name
                          userState.setMe(await AccountApi().updateProfile(
                              Account(
                                      userId: userState.me!.userId,
                                      username: userState.me!.username,
                                      displayName: name,
                                      status: userState.me!.status)
                                  .toDto()));
                        } catch (e) {
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
                        ),
                        title: const Text(
                          "Display Name",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        subtitle: Text(
                          (userState.me!.displayName ?? userState.me!.username),
                          style: const TextStyle(fontSize: 18),
                          maxLines: 1,
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
                          "Please enter your Status",
                          statusController,
                        );
                        try {
                          if (status == null || status.isEmpty) {
                            return;
                          }
                          //send post request to server to update display name
                          userState.setMe(await AccountApi().updateProfile(
                              Account(
                                      userId: userState.me!.userId,
                                      username: userState.me!.username,
                                      displayName: userState.me!.displayName,
                                      status: status)
                                  .toDto()));
                        } catch (e) {
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
                          (userState.me!.status ?? "Hi! I'm using USTalk."),
                          style: const TextStyle(fontSize: 18),
                          maxLines: 1,
                        ),
                        trailing: Icon(Icons.edit,
                            color: Theme.of(context).primaryColor),
                      )),
                ],
              ),
            ));
  }

  Future<String?> inputDialog(
          String title, String hint, TextEditingController controller) =>
      showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: hint),
            controller: controller,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  submitDialog(controller);
                },
                child: const Text('Submit'))
          ],
        ),
      );
  void submitDialog(TextEditingController controller) {
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }
}
