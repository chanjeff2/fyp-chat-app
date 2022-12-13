import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({Key? key}) : super(key: key);

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    // Add default items to list
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Contact"),
      ),
      body: ListView.builder(
      itemCount: _contacts.length + 3,
      itemBuilder: (context, index) {
        switch (index) {
          case 0: {
            return InkWell(
              onTap: () {
                /*
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => CreateGroup()));
                */
              },
              child: const DefaultOption(
                icon: Icons.group_add,
                name: "Add group",
              ),
            );
          }
          case 1: {
            return InkWell(
              onTap: () {
                /*
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => AddContacts()));
                */
              },
              child: const DefaultOption(
                icon: Icons.person_add,
                name: "Add contact",
              ),
            );
          }
          case 2: {
            return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Text("Contacts on USTalk",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                    );
          }
          default: { return const ContactOption(); }
        }
      })
    );
  }
}

// Class for default options
class DefaultOption extends StatelessWidget {
  const DefaultOption({Key? key, required this.name, required this.icon}) : super(key: key);
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

// Placeholder class, as we haven't planned on how to fetch contact
class ContactOption extends StatelessWidget {
  const ContactOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// modal class for Contact
class Contact {
   String nickname, status, id;
   Image img;
   Contact({required this.nickname, required this.status, required this.id, required this.img});
}