import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/palette.dart';
import 'package:fyp_chat_app/models/chat_message.dart';
import 'package:fyp_chat_app/screens/chatroom/chatroom_screen.dart';
import 'package:fyp_chat_app/screens/chatroom/chatroom_screen_group.dart';
import 'package:fyp_chat_app/signal/signal_client.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../models/chatroom.dart';
import '../../models/user_state.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview({Key? key, required this.video, required this.chatroom}) : super(key: key);

  final File video;
  final Chatroom chatroom;

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {

  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.video)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized,
        // even before the play button has been pressed. DO NOT REMOVE
        setState(() {});
      });
  }

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
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : Container(),
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
              // The play button at center
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: CircleAvatar(
                    radius: 33,
                    backgroundColor: Colors.black38,
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Palette.ustBlue[500],
          onPressed: () async {
            // TODO: Send message to chatroom
            try {
              await SignalClient().sendMediaToChatroom(
                userState.me!,
                widget.chatroom,
                widget.video,
                widget.video.path, 
                MessageType.video,
              );
            } on Exception catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("error: $e")));
            }
              

            // return to chatroom
            switch (widget.chatroom.type) {
              case ChatroomType.oneToOne:
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => ChatRoomScreen(chatroom: widget.chatroom)),
                  (route) => false
                );
              break;
              case ChatroomType.group:
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => ChatRoomScreenGroup(chatroom: widget.chatroom)),
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