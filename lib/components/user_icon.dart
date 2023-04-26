import 'package:flutter/material.dart';
class UserIcon extends StatelessWidget {
  const UserIcon({Key? key,
                  this.profilePicUrl,
                  this.radius = 28,
                  this.iconSize = 28,
                  this.isGroup = false,
                }) : super(key: key);

  final String? profilePicUrl;
  final double radius;
  final double iconSize;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: radius,
        backgroundColor: profilePicUrl == null ? Colors.blueGrey : null,
        child: profilePicUrl == null
                ? (isGroup
                  ? Icon(Icons.group, size: iconSize, color: Colors.white)
                  : Icon(Icons.person, size: iconSize, color: Colors.white))
                : ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(profilePicUrl!),
                        fit: BoxFit.fill,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
      );
  }
}