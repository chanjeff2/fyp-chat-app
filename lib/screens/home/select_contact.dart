import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/default_option.dart';
import 'package:fyp_chat_app/components/contact_option.dart';

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
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ListView.builder(
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
        }),
      ) 
      
    );
  }
}

// modal class for Contact, can remove later
class Contact {
   String nickname, status, id;
   Image img;
   Contact({required this.nickname, required this.status, required this.id, required this.img});
}