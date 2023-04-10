import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/palette.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/screens/camera/camera_screen.dart';
import 'package:fyp_chat_app/screens/camera/image_preview.dart';
import 'package:image_picker/image_picker.dart';

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
    return SizedBox(
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
                  () {}
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
                  () {}
                ),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}