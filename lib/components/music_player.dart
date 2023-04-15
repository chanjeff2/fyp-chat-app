import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fyp_chat_app/components/palette.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key,
                      required this.audio,
                      required this.isSender
                    }) : super(key: key);

  final String audio;
  final bool isSender;

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    setAudio();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = (state == PlayerState.playing);
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.stop);

    audioPlayer.setSourceUrl(widget.audio);
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
        maxHeight: MediaQuery.of(context).size.height * 0.1,
      ),
      child: 
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: (widget.isSender) ? Palette.ustGrey.shade500 : Palette.ustGrey.shade900,
              child: IconButton(
                onPressed: () async {
                  if (_isPlaying) {
                    await audioPlayer.pause();
                  } else {
                    await audioPlayer.resume();
                  }
                },
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                )
              ),
            ),
            Column(
              children: [
                Slider(
                  thumbColor: (widget.isSender) ? Colors.white : Palette.ustBlue.shade500,
                  activeColor: (widget.isSender) ? Colors.white : Palette.ustBlue.shade500,
                  inactiveColor: (widget.isSender) ? Palette.ustGrey.shade500 : Palette.ustGrey.shade500,
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await audioPlayer.seek(position);

                    await audioPlayer.resume();
                  }
                ),
                Row(
                  children: [
                    Text(
                      formatTime(position),
                      style: TextStyle(
                        color: (widget.isSender) ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                    Text(
                      formatTime(duration),
                      style: TextStyle(
                        color: (widget.isSender) ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            )
            
          ],
        )
      ),
    );
  }
}