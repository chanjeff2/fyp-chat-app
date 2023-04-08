import 'package:flutter/material.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/group_member.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/network/group_chat_api.dart';
import 'package:fyp_chat_app/screens/chatroom/chatroom_screen.dart';
import 'package:fyp_chat_app/screens/home/create_group_screen.dart';
import 'package:fyp_chat_app/storage/chatroom_store.dart';
import 'package:fyp_chat_app/storage/group_member_store.dart';
import 'package:provider/provider.dart';
import 'package:fyp_chat_app/models/chatroom.dart';

class ContactInfo extends StatelessWidget {
  const ContactInfo({
    Key? key,
    required this.chatroom,
  }) : super(key: key);

  final Chatroom chatroom;

  // Change the data type of the lists below if necessary
  static List<int> _media = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  static List<int> _common_group = [1, 2, 3];
  static List<int> _members = [1, 2, 3];
  static bool isGroup = false;

  // Placeholder lists, can remove later
  static List<Color> _colors = [Colors.amber, Colors.red, Colors.green];
  static List<IconData> _icons = [Icons.edit, Icons.rocket, Icons.forest];
  static List<String> _groupnames = [
    "UST COMP study group",
    "Team Rocket",
    "Dragon's Back Hikers"
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) => Scaffold(
        appBar: AppBar(
          leadingWidth: 24,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Row(
            children: <Widget>[
              const CircleAvatar(
                // child: profilePicture ? null : Icon(Icons.person, size: 20),
                child: Icon(Icons.person, size: 20, color: Colors.white),
                radius: 20,
                backgroundColor: Colors.blueGrey,
              ),
              const SizedBox(width: 12),
              Text(chatroom.name),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: CircleAvatar(
                  radius: 72,
                  // child: profilePicture ? null : Icon(Icons.person, size: 48),
                  // backgroundImage: profileImage,
                  child: Icon(Icons.person, size: 72, color: Colors.white),
                  backgroundColor: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 14),
              Text(chatroom.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                  )),
              Text(
                // isGroup ? "Group - $participants participants" : "Known as $user.username"
                chatroom.type == ChatroomType.group
                    ? chatroom.name +
                        " participants: " +
                        ((chatroom as GroupChat).members.length).toString()
                    : chatroom.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 14),
              // Option buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Notification button
                  Column(children: [
                    InkWell(
                      onTap: () {
                        print("Mute notifications from testuser");
                      },
                      child: Ink(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white70,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Mute",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ]),
                  const SizedBox(width: 32),
                  // Search button
                  Column(children: [
                    InkWell(
                      onTap: () {
                        print("Search");
                      },
                      child: Ink(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white70,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Search",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ]),
                  (chatroom.type == ChatroomType.group)
                      ? const SizedBox(width: 32)
                      : const SizedBox(width: 0),
                  (chatroom.type == ChatroomType.group)
                      ? Column(children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CreateGroupScreen(
                                  isCreateGroup: false,
                                  group: chatroom as GroupChat,
                                ),
                              ));
                            },
                            child: Ink(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white70,
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Add",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ])
                      : const SizedBox(width: 0),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(thickness: 2, indent: 8, endIndent: 8),
              // Status / Group description
              GestureDetector(
                child: ListTile(
                  title: Text(
                    isGroup ? "Group description" : "Status",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: const Text(
                    "Hi! I'm using USTalk.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const Divider(thickness: 2, indent: 8, endIndent: 8),
              /*
              // Disappearing Messages
              InkWell(
                onTap: () {/* isGroup ? EditGroupDescription : null */},
                child: ListTile(
                  leading: const SizedBox(
                    height: double.infinity,
                    child: Icon(Icons.speed_rounded, color: Colors.black),
                  ),
                  title: const Text(
                    "Disappearing Messages",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    "Off", // disappearing ? "On" : "Off"
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              */
              // Check security number * DON'T SHOW THIS IN GROUP INFO *
              InkWell(
                  onTap: () {/* isGroup ? EditGroupDescription : null */},
                  child: ListTile(
                      leading: const SizedBox(
                        height: double.infinity,
                        child: Icon(Icons.verified_user_outlined,
                            color: Colors.black),
                      ),
                      title: const Text(
                        "View public key",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      subtitle: (chatroom.type == ChatroomType.group)
                          ? Text(
                              "All messages are end-to-end encrypted.Tap to see your key.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            )
                          : Text(
                              "All messages are end-to-end encrypted.Tap to see your group key.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ))),
              const Divider(thickness: 2, indent: 8, endIndent: 8),
              // Shared Media
              Row(
                children: [
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Shared Media",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 92,
                        width: MediaQuery.of(context).size.width - 32,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: _media.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  if (index > 0) ...[const SizedBox(width: 8)],
                                  Container(
                                    padding: const EdgeInsets.all(30),
                                    decoration: const BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    child: const Icon(
                                      Icons.image,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 32,
                        child: InkWell(
                          onTap: () {/* View all media */},
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "View All", // isGroup ? "Group description" : "Status",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              const Divider(thickness: 2, indent: 8, endIndent: 8),
              // Group members
              (chatroom.type == ChatroomType.group)
                  ? Row(
                      children: const [
                        SizedBox(width: 16),
                        Text(
                          "Participants:", // isGroup ? "$participants members" : "$groups groups in common",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: const [
                        SizedBox(width: 16),
                        Text(
                          "No groups in common", // isGroup ? "$participants members" : "$groups groups in common",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 8),
              (chatroom.type == ChatroomType.group)
                  ?
                  //Group List View
                  ListView.builder(
                      // +1 for add members / create group with the user
                      shrinkWrap: true,
                      itemCount: (chatroom as GroupChat).members.length + 1,
                      itemBuilder: (context, index) {
                        // Add member / add to group
                        if (index == 0) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CreateGroupScreen(
                                  isCreateGroup: false,
                                  group: chatroom as GroupChat,
                                ),
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  const SizedBox(width: 16),
                                  const CircleAvatar(
                                    radius: 24,
                                    child: Icon(Icons.add,
                                        size: 24, color: Colors.white),
                                    backgroundColor: Colors.blueGrey,
                                  ),
                                  const SizedBox(width: 16),
                                  Text("Add members...",
                                      style: const TextStyle(fontSize: 16))
                                ],
                              ),
                            ),
                          );
                        }

                        // Group members
                        return InkWell(
                          onTap: () async {
                            /* direct to OneToOne chat */
                            Chatroom? pmChatroom = await ChatroomStore().get(
                                (chatroom as GroupChat)
                                    .members[index - 1]
                                    .user
                                    .userId);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ChatRoomScreen(chatroom: pmChatroom!)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                CircleAvatar(
                                  radius: 24,
                                  child: Icon(Icons.person,
                                      size: 28, color: Colors.white),
                                  backgroundColor: Colors.blueGrey,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                    // isGroup ? _members[index].name : _common_group[index].name,
                                    ((chatroom as GroupChat)
                                                .members[index - 1]
                                                .user
                                                .displayName ==
                                            null)
                                        ? (chatroom as GroupChat)
                                            .members[index - 1]
                                            .user
                                            .username
                                        : (chatroom as GroupChat)
                                            .members[index - 1]
                                            .user
                                            .displayName!,
                                    style: const TextStyle(fontSize: 16))
                              ],
                            ),
                          ),
                        );
                      })
                  :
                  // oneToOne Chatroom List View
                  ListView.builder(
                      // +1 for add members / create group with the user
                      shrinkWrap: true,
                      itemCount: _common_group.length + 1,
                      itemBuilder: (context, index) {
                        // Add member / add to group
                        if (index == 0) {
                          return InkWell(
                            onTap: () {/* isGroup ? addMember : addGroup */},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  const SizedBox(width: 16),
                                  const CircleAvatar(
                                    radius: 24,
                                    child: Icon(Icons.add,
                                        size: 24, color: Colors.white),
                                    backgroundColor: Colors.blueGrey,
                                  ),
                                  const SizedBox(width: 16),
                                  Text("Add to a group",
                                      style: const TextStyle(fontSize: 16))
                                ],
                              ),
                            ),
                          );
                        }
                        // Common groups
                        return InkWell(
                          onTap: () {/* direct to respective chat */},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                CircleAvatar(
                                  radius: 24,
                                  child: Icon(_icons[index - 1],
                                      size: 24, color: Colors.white),
                                  backgroundColor: _colors[index - 1],
                                ),
                                const SizedBox(width: 16),
                                Text(
                                    // isGroup ? _members[index].name : _common_group[index].name,
                                    isGroup
                                        ? "Add members..."
                                        : _groupnames[index - 1],
                                    style: const TextStyle(fontSize: 16))
                              ],
                            ),
                          ),
                        );
                      }),
              const Divider(thickness: 2, indent: 8, endIndent: 8),
              // Block / Leave group
              if (isGroup) ...[
                InkWell(
                  onTap: () {/* confirm => process leave group */},
                  child: const ListTile(
                    leading:
                        Icon(Icons.exit_to_app, size: 24, color: Colors.red),
                    title: Text(
                      "Leave Group",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                ),
              ],
              InkWell(
                onTap: () {/* block user */},
                child: ListTile(
                  leading: const Icon(Icons.block, size: 24, color: Colors.red),
                  title: Text(
                    "Block${isGroup ? ' Group' : ''}",
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
