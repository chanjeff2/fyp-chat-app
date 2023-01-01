import 'package:flutter/material.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:provider/provider.dart';
import 'package:fyp_chat_app/screens/chatroom/message_bubble.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _textMessage = false;
  bool _emojiBoardShown = false;
  //temporary message storage in array
  final List<Widget> _messages = [];

  void _submitMsg(String message) {
    // Get the current time
    DateTime now = DateTime.now();
    String parsedTime = "${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}";
    //add the text into message array for temporary storage
    setState(() {
      _messages.insert(
          0,
          Container(
              child: MessageBubble(text: message, time: parsedTime, isCurrentUser: true),
              alignment: Alignment.centerRight));
    });
    _messageController.clear();
    _textMessage = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) => Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: const [
                Expanded(
                  child: Icon(
                    Icons.arrow_back,
                  ),
                ),
                // SizedBox(width: 4),
                Expanded(
                  child: CircleAvatar(
                  // child: profilePicture ? null : Icon(Icons.person, size: 48),
                    child: Icon(Icons.person, size: 20, color: Colors.white),
                    radius: 32,
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
          //top bar with pop up menu button
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Test user"), //TODO: add target name to title
              Text("Online",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14
                ),
              ),
            ],
          ),
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                _onMenuItemSelected(value as int, userState);
              },
              itemBuilder: (context) => [
                _buildPopupMenuItem("Add to Contact", 0),
                _buildPopupMenuItem("Search", 1),
                _buildPopupMenuItem("Mute Notifications", 2),
                PopupMenuItem(
                  value: 3,
                  child: PopupMenuButton(
                    padding: EdgeInsets.zero,
                    child: Container(
                      alignment: Alignment.center,
                      height: 48.0, //default height
                      width: double.infinity,
                      child: Row(
                              children: const <Widget>[
                                Text("More"),
                                Spacer(),
                                Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                              ],
                            ),
                    ),
                    itemBuilder: (innerContext) {
                      return [
                        PopupMenuItem(
                          value: 101,
                          child: const Text("Block User"),
                          onTap: () { Navigator.of(innerContext).pop(); },
                        ),
                        PopupMenuItem(
                          value: 102,
                          child: const Text("Report User"),
                          onTap: () { Navigator.of(innerContext).pop(); },
                        ),
                      ];
                    },
                    ),
                ),
              ],
            )
          ],
        ),
        body: Column(children: <Widget>[
          //show chat messages on screen
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) => _messages[index],
              itemCount: _messages.length,
              reverse: true,
            ),
          ),
          //show text field bar and related button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(children: <Widget>[
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade600),
                    borderRadius: BorderRadius.circular(16.0)
                  ),
                  child: Scrollbar(
                    controller: _scrollController,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.multiline,
                      controller: _messageController,
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Colors.blue.shade900,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        isCollapsed: true,
                        filled: true,
                        fillColor: Colors.white70,
                        hintText: 'Message',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                        prefixIcon: IconButton(
                            icon: _emojiBoardShown
                                ? Icon(Icons.keyboard, color: Colors.grey.shade600)
                                : Icon(Icons.emoji_emotions_outlined, color: Colors.grey.shade600),
                            onPressed: () {
                              setState(() {
                                _emojiBoardShown = !_emojiBoardShown;
                              });
                            },
                          ),
                        suffixIcon: (_textMessage)
                            ? null
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.attach_file, color: Colors.grey.shade600),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.camera_alt, color: Colors.grey.shade600),
                                    onPressed: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (builder) =>
                                      //             CameraApp()));
                                    },
                                  ),
                                ],
                              ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          _textMessage = text.isNotEmpty;
                        });
                      },
                      minLines: 1,
                      maxLines: 5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).primaryColor,
                child: IconButton(
                  icon: _textMessage
                      ? const Icon(Icons.send, color: Colors.white)
                      : const Icon(Icons.mic, color: Colors.white),
                  onPressed: () => {
                    if (_textMessage) {_submitMsg(_messageController.text)}
                  },
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem(String title, int positon) {
    return PopupMenuItem(
      value: positon,
      child: Text(title),
    );
  }

  _onMenuItemSelected(int value, UserState userState) {
    switch (value) {
      case 0: {
        break;
      }
      case 1: {
        break;
      }
      case 2: {
        break;
      }
      case 3: {
        break;
      }
    }
  }
}
