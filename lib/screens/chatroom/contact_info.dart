import 'package:flutter/material.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:provider/provider.dart';


class ContactInfo extends StatelessWidget {
  const ContactInfo({Key? key}) : super(key: key);

  // Change the data type of the lists below if necessary
  static List<int> _media = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  static List<int> _common_group = [1, 2, 3];
  static List<int> _members = [1, 2, 3];
  static bool isGroup = false;

  // Placeholder lists, can remove later
  static List<Color> _colors = [Colors.amber, Colors.red, Colors.green];
  static List<IconData> _icons = [Icons.edit, Icons.rocket, Icons.forest];
  static List<String> _groupnames = ["UST COMP study group", "Team Rocket", "Dragon's Back Hikers"];

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder:(context, userState, child) => Scaffold(
        appBar: AppBar(
          leadingWidth: 24,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Row(
            children: const <Widget>[
              CircleAvatar(
                // child: profilePicture ? null : Icon(Icons.person, size: 20),
                child: Icon(Icons.person, size: 20, color: Colors.white),
                radius: 20,
                backgroundColor: Colors.blueGrey,
              ),
              SizedBox(width: 12),
              Text("testuser"),
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
              const Text(
                "Test user",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                )
              ),
              Text(
                // isGroup ? "Group - $participants participants" : "Known as $user.username"
                isGroup ? "Group - 87 participants" : "Known as testuser",
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
                  Column(
                    children: [
                      InkWell(
                        onTap: () { print("Mute notifications from testuser"); },
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
                    ]
                  ),
                  const SizedBox(width: 32),
                  // Search button
                  Column(
                    children: [
                      InkWell(
                        onTap: () { print("Search"); },
                        child: Ink(
                          padding: const EdgeInsets.all(12),
                          decoration:  const BoxDecoration(
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
                    ]
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(thickness: 2, indent: 8, endIndent: 8),
              // Status / Group description
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: () { /* isGroup ? EditGroupDescription : null */ },
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isGroup ? "Group description" : "Status",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            "Hi! I'm using USTalk.",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(thickness: 2, indent: 8, endIndent: 8),
              // Disappearing Messages
              InkWell(
                onTap: () { /* isGroup ? EditGroupDescription : null */ },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Icon(Icons.speed_rounded),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Disappearing Messages",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Off", // disappearing ? "On" : "Off"
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              // Check security number * DON'T SHOW THIS IN GROUP INFO *
              if (!isGroup) ...[
                InkWell(
                  onTap: () { /* isGroup ? EditGroupDescription : null */ },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        const Icon(Icons.verified_user_outlined),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "View Safety number",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "All messages are end-to-end encrypted.Tap to verify.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
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
                                  decoration:  const BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ],
                            );
                          }
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 32,
                        child: InkWell(
                          onTap: () { /* View all media */ },
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
              // Common Group / Group members
              Row(
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
              ListView.builder(
                // +1 for add members / create group with the user
                shrinkWrap: true,
                itemCount: (isGroup ? _members.length : _common_group.length) + 1,
                itemBuilder: (context, index) {
                  // Add member / add to group
                  if (index == 0) {
                    return InkWell(
                      onTap: () { /* isGroup ? addMember : addGroup */} ,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            const CircleAvatar(
                              radius: 24,
                              child: Icon(Icons.add, size: 24, color: Colors.white),
                              backgroundColor: Colors.blueGrey,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              isGroup ? "Add members..." : "Add to a group",
                              style: const TextStyle(
                                fontSize: 16
                              )
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  // Group members / Common groups
                  return InkWell(
                    onTap: () { /* direct to respective chat */ } ,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          CircleAvatar(
                            radius: 24,
                            child: Icon(_icons[index-1], size: 24, color: Colors.white),
                            backgroundColor: _colors[index-1],
                          ),
                          const SizedBox(width: 16),
                          Text(
                            // isGroup ? _members[index].name : _common_group[index].name,
                            isGroup ? "Add members..." : _groupnames[index-1],
                            style: const TextStyle(
                              fontSize: 16
                            )
                          )
                        ],
                      ),
                    ),
                  );
                }
              ),
              const Divider(thickness: 2, indent: 8, endIndent: 8),
              // Block / Leave group
              if (isGroup) ...[
                InkWell(
                  onTap: () { /* confirm => process leave group */ } ,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: const [
                        SizedBox(width: 16),
                        Icon(Icons.exit_to_app, size: 24, color: Colors.red),
                        SizedBox(width: 16),
                        Text(
                          "Leave Group",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18
                          )
                        )
                      ],
                    ),
                  ),
                ),
              ],
              InkWell(
                onTap: () { /* block user */ } ,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Icon(Icons.block, size: 24, color: Colors.red),
                      const SizedBox(width: 16),
                      Text(
                        "Block${isGroup ? ' Group' : ''}",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18
                        )
                      )
                    ],
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