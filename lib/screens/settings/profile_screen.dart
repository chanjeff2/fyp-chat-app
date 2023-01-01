import 'package:flutter/material.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder:(context, userState, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  const CircleAvatar(
                    radius: 72,
                    // child: profilePicture ? null : Icon(Icons.person, size: 48),
                    // backgroundImage: profileImage,
                    child: Icon(Icons.person, size: 72, color: Colors.white),
                    backgroundColor: Colors.blueGrey,
                  ),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(Icons.camera_alt, color: Colors.black),
                        ),
                        decoration: BoxDecoration(
                        border: Border.all(
                          width: 6,
                          color: Colors.white,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(2, 4),
                            color: Colors.black.withOpacity(
                              0.3,
                            ),
                            blurRadius: 3,
                          ),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Display name
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.person, color: Colors.black, size: 30,),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Display Name", 
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        
                        Text(
                          userState.me!.displayName ?? userState.me!.username,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(Icons.edit, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
            const Divider(thickness: 2, indent: 62),
            // Status
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.info_outline, color: Colors.black, size: 30,),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Status", 
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        
                        Text(
                          // ${userState.me!.displayName ?? userState.me!.username}
                          "Hi! I'm using USTalk.",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(Icons.edit, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}