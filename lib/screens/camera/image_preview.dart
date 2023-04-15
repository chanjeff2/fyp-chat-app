import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/palette.dart';
import 'package:fyp_chat_app/models/chat_message.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/media_message.dart';
import 'package:fyp_chat_app/signal/signal_client.dart';
import 'package:provider/provider.dart';

import '../../models/user_state.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({Key? key,
                      required this.image,
                      required this.chatroom,
                      required this.sendCallback,
                      this.saveImage = false,
                    }) : super(key: key);

  final File image;
  final Chatroom chatroom;
  final bool saveImage;
  final Function(MediaMessage) sendCallback;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {

  bool _isSending = false;


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
                  widget.image,
                  fit: BoxFit.contain,
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
          backgroundColor: (_isSending) ? Colors.grey : Palette.ustBlue[500],
          onPressed: () async {
            if (!_isSending) {
              try {
                setState(() {
                  _isSending = true;
                });
                final mediaMessage = await SignalClient().sendMediaToChatroom(
                  userState.me!,
                  widget.chatroom,
                  widget.image,
                  widget.image.path, 
                  MessageType.image,
                );
                widget.sendCallback(mediaMessage);
              } on Exception catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("error: $e")));
              }

              // return to chatroom
              switch (widget.chatroom.type) {
                case ChatroomType.oneToOne:
                  Navigator.of(context).popUntil(
                    (route) => route.settings.name == "/chatroom/${widget.chatroom.id}"
                  );
                break;
                case ChatroomType.group:
                  Navigator.of(context).popUntil(
                    (route) => route.settings.name == "/chatroom-group/${widget.chatroom.id}"
                  );
                break;
              }
              setState(() {
                _isSending = false;
              });
            }
          },
          child: Icon(
            (_isSending) ? Icons.hourglass_top : Icons.send,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    ); 
  }
}