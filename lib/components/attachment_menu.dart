import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/palette.dart';
import 'package:fyp_chat_app/models/chat_message.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/screens/camera/camera_screen.dart';
import 'package:fyp_chat_app/screens/camera/image_preview.dart';
import 'package:fyp_chat_app/signal/signal_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AttachmentMenu extends StatelessWidget {
  const AttachmentMenu({
    Key? key,
    required this.chatroom
  }) : super(key: key);

  final Chatroom chatroom;

  Widget createIcon(IconData icons, Color color, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) => SizedBox(
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  createIcon(
                    Icons.insert_drive_file,
                    Palette.darkSteelBlue,
                    "Document",
                    () async {
                      final result = await FilePicker.platform.pickFiles();
                      
                      if (result != null) {
                        return;
                      }

                      try {
                        await SignalClient().sendMediaToChatroom(
                          userState.me!,
                          chatroom,
                          File(result!.files.first.path!),
                          result.files.first.path, 
                          MessageType.document,
                        );
                      } on Exception catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("error: $e")));
                      }
                    }
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  createIcon(
                    Icons.camera_alt,
                    Palette.firebirdRed,
                    "Camera",
                    () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => 
                        CameraScreen(source: Source.chatroom, chatroom: chatroom)
                      ));
                    }
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  createIcon(
                    Icons.insert_photo,
                    Palette.darkRed,
                    "Gallery",
                    () async {
                      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (image == null) return;
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                        ImagePreview(image: File(image.path), chatroom: chatroom)
                      ));
                    }
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  createIcon(
                    Icons.headset,
                    Palette.orange,
                    "Audio",
                    () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.audio,
                      );
                      
                      if (result != null) {
                        return;
                      }

                      try {
                        await SignalClient().sendMediaToChatroom(
                          userState.me!,
                          chatroom,
                          File(result!.files.first.path!),
                          result.files.first.path, 
                          MessageType.document,
                        );
                      } on Exception catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("error: $e")));
                      }
                    }
                  ),
                  /*
                  const SizedBox(
                    width: 40,
                  ),
                  createIcon(
                    Icons.location_pin,
                    Palette.lightSeaGreen,
                    "Location",
                    () {}
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  createIcon(
                    Icons.bar_chart_rounded,
                    Palette.oceanBlue,
                    "Poll",
                    () {}
                  ),
                  */
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}