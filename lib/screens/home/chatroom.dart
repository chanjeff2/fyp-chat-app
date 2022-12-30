import 'package:flutter/material.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/storage/credential_store.dart';
import 'package:provider/provider.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);
  void _submitMsg(String text) {
    print(text);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textController = TextEditingController();
    return Consumer<UserState>(
      builder: (context, userState, child) => Scaffold(
        appBar: AppBar(
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
                    child: const Text("More..."),
                  ),
                ),
              ],
            )
          ],
        ),
        body: Column(children: <Widget>[
          const Expanded(
            child: Text('Test Screen'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(children: <Widget>[
              Flexible(
                child: TextField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(16.0),
                      border: OutlineInputBorder(),
                      hintText: 'Type something...'),
                  controller: _textController,
                  onSubmitted: _submitMsg,
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _submitMsg(_textController.text),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  addContact() {}
}
