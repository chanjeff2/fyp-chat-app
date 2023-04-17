import 'package:flutter/material.dart';

// Class for default options
class DefaultOption extends StatelessWidget {
  const DefaultOption({Key? key, required this.name, required this.icon})
      : super(key: key);
  final String name;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF003366),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
