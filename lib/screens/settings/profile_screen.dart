import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/user_icon.dart';
import 'package:fyp_chat_app/dto/update_user_dto.dart';
import 'package:fyp_chat_app/models/account.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/screens/camera/camera_screen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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

  void _showBottomSheet(BuildContext context, UserState userState) {
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
                                      "Are you sure that you want to remove your icon?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        try {
                                          // TODO: remove profile pic
                                          Navigator.pop(context);
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => const CameraScreen(
                                    source: Source.personalIcon,
                                  )))
                          .then((value) async {
                        if (value == null) return;
                        CroppedFile? croppedFile =
                            await ImageCropper().cropImage(
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
                              lockAspectRatio: true,
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
                        userState.setMe(await AccountApi()
                            .updateProfilePic(File(croppedFile.path)));
                        Navigator.pop(context);
                      }),
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
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image == null) return;
                        CroppedFile? croppedFile =
                            await ImageCropper().cropImage(
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
                                lockAspectRatio: true),
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
                        userState.setMe(await AccountApi()
                            .updateProfilePic(File(croppedFile.path)));
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
            ));
      },
    );
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
                            onTap: () {
                              _showBottomSheet(context, userState);
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
                          // send post request to server to update display name
                          final me = await AccountApi()
                              .updateProfile(UpdateUserDto(displayName: name));
                          userState.setMe(me);
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
                          // send post request to server to update status
                          final me = await AccountApi()
                              .updateProfile(UpdateUserDto(status: status));
                          userState.setMe(me);
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
