import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/palette.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/screens/chatroom/chatroom_screen.dart';
import 'package:fyp_chat_app/screens/chatroom/chatroom_screen_group.dart';
import 'package:provider/provider.dart';

import '../../models/user_state.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({Key? key,
                      required this.image,
                      required this.chatroom,
                      this.saveImage = false,
                    }) : super(key: key);

  final File image;
  final Chatroom chatroom;
  final bool saveImage;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leadingWidth: 56,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          /* Commented out, implement if time is allowed
          actions: [
            // Crop
            IconButton(
              icon: const Icon(
                Icons.crop_rotate,
                size: 28,
              ),
              onPressed: () {}
            ),
            // Add emoji
            IconButton(
              icon: const Icon(
                Icons.emoji_emotions_outlined,
                size: 28,
              ),
              onPressed: () {}
            ),
            // Add text
            IconButton(
              icon: const Icon(
                Icons.title,
                size: 28,
              ),
              onPressed: () {}
            ),
            // Edit
            IconButton(
              icon: const Icon(
                Icons.edit,
                size: 28,
              ),
              onPressed: () {}
            ),
          ],
          */
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 150,
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              /* Comment out for now, if time allows to add caption to images
              Positioned(
                bottom: 0,
                child: Container(
                  color: Colors.black38,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add Caption....",
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add_photo_alternate,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      suffixIcon: CircleAvatar(
                        radius: 28,
                        backgroundColor: Palette.ustBlue[500],
                        child: IconButton(
                        onPressed: () {
                          // TODO: Send message to chatroom

                          // return to chatroom
                          switch (chatroom.type) {
                            case ChatroomType.oneToOne:
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => ChatRoomScreen(chatroom: chatroom)),
                                (route) => false
                              );
                            break;
                            case ChatroomType.group:
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => ChatRoomScreenGroup(chatroom: chatroom)),
                                (route) => false
                              );
                            break;
                          }
                        },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 27,
                          ),
                        ),
                      )),
                  ),
                ),
              ),
              */
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Palette.ustBlue[500],
          onPressed: () async {
            // TODO: Send message to chatroom


            // return to chatroom
            switch (chatroom.type) {
              case ChatroomType.oneToOne:
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => ChatRoomScreen(chatroom: chatroom)),
                  (route) => false
                );
              break;
              case ChatroomType.group:
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => ChatRoomScreenGroup(chatroom: chatroom)),
                  (route) => false
                );
              break;
            }
          },
          child: const Icon(
            Icons.send,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    ); 
  }
}