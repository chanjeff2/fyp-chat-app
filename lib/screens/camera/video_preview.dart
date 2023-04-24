import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/palette.dart';
import 'package:fyp_chat_app/models/chat_message.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/media_message.dart';
import 'package:fyp_chat_app/signal/signal_client.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../models/chatroom.dart';
import '../../models/user_state.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview({
    Key? key,
    required this.video,
    required this.chatroom,
    required this.sendCallback,
  }) : super(key: key);

  final File video;
  final Chatroom chatroom;
  final Function(MediaMessage) sendCallback;

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late final VideoPlayerController _controller;
  late final ChewieController _chewieController;
  late final Future<void> _future;

  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.video);
    _future = initVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _chewieController.dispose();
  }

  Future<void> initVideoPlayer() async {
    await _controller.initialize();
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        aspectRatio: _controller.value.aspectRatio,
        autoPlay: false,
        looping: false,
      );
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) => WillPopScope(
        onWillPop: () async => !_isSending,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leadingWidth: 56,
            leading: _isSending
                ? const Icon(
                    Icons.hourglass_top,
                    color: Colors.white,
                  )
                : IconButton(
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
          body: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 150,
                          child: AspectRatio(
                            aspectRatio: _chewieController.aspectRatio!,
                            child: Chewie(controller: _chewieController),
                          )),
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
                      /*
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
                      */
                    ],
                  ),
                );
              }),
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
                    widget.video,
                    widget.video.path,
                    MessageType.video,
                  );
                  widget.sendCallback(mediaMessage);
                } on Exception catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("error: $e")));
                }

                // return to chatroom
                switch (widget.chatroom.type) {
                  case ChatroomType.oneToOne:
                    Navigator.of(context).popUntil((route) =>
                        route.settings.name ==
                        "/chatroom/${widget.chatroom.id}");
                    break;
                  case ChatroomType.group:
                    Navigator.of(context).popUntil((route) =>
                        route.settings.name ==
                        "/chatroom-group/${widget.chatroom.id}");
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
      ),
    );
  }
}
