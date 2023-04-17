import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideoPlayer extends StatefulWidget {
  const VideoPlayer({Key? key, required this.video}) : super(key: key);

  final File video;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late final VideoPlayerController _controller;
  late final ChewieController _chewieController;
  Future<void>? _future;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
      widget.video,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false),
    );
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
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return AspectRatio(
            aspectRatio: _chewieController.aspectRatio!,
            child: Chewie(controller: _chewieController),
          );
        },
      ),
    );
  }

}