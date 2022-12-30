import 'package:flutter/material.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:provider/provider.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _textMessage = false;
  bool _emojiBoardShown = false;
  //temporary message storage in array
  final List<Widget> _messages = [];

  void _submitMsg(String message) {
    //add the text into message array for temporary storage
    setState(() {
      _messages.insert(
          0, Container(child: Text(message), alignment: Alignment.centerRight));
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.arrow_back,
                  size: 24,
                ),
                CircleAvatar(
                  // child: profilePicture ?? Icon(Icons.person, size: 24),
                  child: Icon(Icons.person, size: 24, color: Colors.white),
                  radius: 16,
                  backgroundColor: Colors.blueGrey,
                ),
              ],
            ),
          ),
          //top bar with pop up menu button
          title: const Text("ChatRoom with"),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Add to Contact"),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Search"),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Mute Notifications"),
                  ),
                ),
                PopupMenuItem(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: PopupMenuButton(
                      child: const Text(
                        "More...",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      itemBuilder: (context) => [
                            PopupMenuItem(
                              child: TextButton(
                                onPressed: () {},
                                child: const Text("Report user"),
                              ),
                            ),
                            PopupMenuItem(
                              child: TextButton(
                                onPressed: () {},
                                child: const Text("Block user"),
                              ),
                            ),
                          ]),
                ),
              ],
            )
          ],
        ),
        body: Column(children: <Widget>[
          //show chat messages on screen
          Expanded(
            child: ListView.builder(
              padding: new EdgeInsets.all(8.0),
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
                child: TextFormField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.lime[800],
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16.0),
                    filled: true,
                    fillColor: Colors.blueGrey[900],
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                    ),
                    hintText: 'Message',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: IconButton(
                      icon: _emojiBoardShown
                          ? const Icon(Icons.keyboard, color: Colors.grey)
                          : const Icon(Icons.emoji_emotions_outlined,
                              color: Colors.grey),
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
                                icon: const Icon(Icons.attach_file,
                                    color: Colors.grey),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.camera_alt,
                                    color: Colors.grey),
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
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xFF003366),
                child: IconButton(
                  icon: _textMessage
                      ? const Icon(Icons.send, color: Colors.white)
                      : const Icon(Icons.mic, color: Colors.white),
                  onPressed: () => _submitMsg(_messageController.text),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
