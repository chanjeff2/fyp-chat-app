import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/user_icon.dart';
import 'package:fyp_chat_app/models/account.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/screens/camera/camera_screen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../network/account_api.dart';

class EditGroupChat extends StatefulWidget {
  const EditGroupChat({Key? key, required this.groupChat}) : super(key: key);

  final GroupChat groupChat;

  @override
  State<EditGroupChat> createState() => _EditGroupChatState();
}

class _EditGroupChatState extends State<EditGroupChat> {
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

  void _showBottomSheet(BuildContext context, GroupChat groupChat) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical( 
          top: Radius.circular(12),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          height: 180,
          child: Column(
            children: [
              Row(
                children: [
                  const Text("Select icon image"),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: const Text(
                                "Are you sure that you want to remove your icon?"
                              ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  try {
                                    // Update DTO
                                    
                                    Navigator.pop(context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString()),
                                      ),
                                    );
                                  }
                                },
                                child: const Text("Remove"),
                              ),
                            ]);
                        });
                    },
                    icon: const Icon(Icons.delete),
                  )
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () =>
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CameraScreen(
                            source: Source.personalIcon,
                          ))
                      ).then((value) async {
                        if (value == null) return;
                        CroppedFile? croppedFile = await ImageCropper().cropImage(
                          sourcePath: (value as File).path,
                          aspectRatioPresets: [
                            CropAspectRatioPreset.square,
                          ],
                          uiSettings: [
                            AndroidUiSettings(
                              toolbarTitle: 'Crop image',
                              toolbarColor: Theme.of(context).primaryColor,
                              toolbarWidgetColor: Colors.white,
                              initAspectRatio: CropAspectRatioPreset.square,
                              lockAspectRatio: true
                            ),
                            IOSUiSettings(
                              title: 'Crop image',
                            ),
                            WebUiSettings(
                              context: context,
                            ),
                          ],
                        );
                        if (croppedFile == null) return;
                        // Upload to server
                        // Update group data locally
                        Navigator.pop(context);
                      }
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blueGrey,
                              width: 1,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(
                                Icons.camera_alt,
                                size: 28,
                              ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Camera",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  InkWell(
                    onTap: () async {
                      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (image == null) return;
                      CroppedFile? croppedFile = await ImageCropper().cropImage(
                        sourcePath: image.path,
                        aspectRatioPresets: [
                          CropAspectRatioPreset.square,
                        ],
                        uiSettings: [
                          AndroidUiSettings(
                            toolbarTitle: 'Crop image',
                            toolbarColor: Theme.of(context).primaryColor,
                            toolbarWidgetColor: Colors.white,
                            initAspectRatio: CropAspectRatioPreset.square,
                            lockAspectRatio: true
                          ),
                          IOSUiSettings(
                            title: 'Crop image',
                          ),
                          WebUiSettings(
                            context: context,
                          ),
                        ],
                      );
                      if (croppedFile == null) return;
                      // Upload to server
                      // Update group data locally
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blueGrey,
                              width: 1,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(
                                Icons.image,
                                size: 28,
                              ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Gallery",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Group"),
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
                  isGroup: true,
                  profilePicUrl: widget.groupChat.profilePicUrl,
                ),
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: GestureDetector(
                    onTap: () {
                      _showBottomSheet(context, widget.groupChat);
                    },
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
          // Group name
          InkWell(
              onTap: () async {
                // Don't allow user to edit group name if it is a course group
                if (widget.groupChat.groupType == GroupType.Course) return;
                String? name = await inputDialog(
                  "Group name",
                  "Please provide a new name for the group",
                  displayNameController,
                );
                try {
                  if (name == null || name.isEmpty) {
                    return;
                  }
                  // send post request to server to update display name
                  // Update locally and globally
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
                  child: Icon(Icons.group, color: Colors.black, size: 30),
                ),
                title: const Text(
                  "Group Name",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                subtitle: Text(
                  widget.groupChat.name,
                  style: const TextStyle(fontSize: 18),
                  maxLines: 1,
                ),
                trailing: (widget.groupChat.groupType == GroupType.Basic)
                          ? Icon(Icons.edit, color: Theme.of(context).primaryColor)
                          : null,
              )),
          const Divider(thickness: 2, indent: 62),
          // Status
          InkWell(
              onTap: () async {
                String? desc = await inputDialog(
                  "Description",
                  "Please provide a new description",
                  statusController,
                );
                try {
                  if (desc == null) {
                    return;
                  }
                  //send post request to server to update display name
                  // Update locally and globally
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
                  "Description",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                subtitle: Text(
                  (widget.groupChat.description ?? "This is a new USTalk group!"),
                  style: const TextStyle(fontSize: 18),
                  maxLines: 1,
                ),
                trailing: Icon(Icons.edit,
                    color: Theme.of(context).primaryColor),
              )),
        ],
      ),
    );
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
