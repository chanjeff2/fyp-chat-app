import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_chat_app/dto/group_member_dto.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/group_member.dart';
import 'package:fyp_chat_app/models/user.dart';
import 'package:fyp_chat_app/screens/chatroom/chatroom_screen_group.dart';
import 'package:fyp_chat_app/screens/register_or_login/loading_screen.dart';

import '../../network/api.dart';

class JoinCourseGroupScreen extends StatefulWidget {
  const JoinCourseGroupScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<JoinCourseGroupScreen> createState() => _JoinCourseGroupScreenState();
}

class _JoinCourseGroupScreenState extends State<JoinCourseGroupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  String get courseCode => _courseCodeController.text;
  String get year => _yearController.text;
  String upperCaseCourseCode = "";
  final List<String> semesters = ["Fall", "Winter", "Spring", "Summer"];
  final RegExp courseCodeFilter = RegExp(r'^[A-Za-z]{4}\d{4}[A-Za-z]?$');
  String semesterSelected = "";
  bool _isLoading = false;
  @override
  void initState() {
    // Add default items to list
    super.initState();
    semesterSelected = semesters[2];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _isLoading
      ? const LoadingScreen()
      : Scaffold(
          appBar: AppBar(
            title: const Text("Join a Course Group"),
          ),
          body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.allow(courseCodeFilter),
                      // ],
                      controller: _courseCodeController,
                      decoration: const InputDecoration(
                        labelText: "Course Code",
                        hintText: "(E.g. COMP4981 or LANG1002A)",
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 15.0,
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide()),
                      ),
                      validator: (courseCode) {
                        if (courseCode?.isEmpty ?? true) {
                          return "Course Code cannot be empty";
                        }
                        if (!courseCodeFilter.hasMatch(courseCode!)) {
                          return "Invalid Course Code";
                        }
                        return null;
                      },
                      enabled: true,
                    ),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(4),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            controller: _yearController,
                            decoration: const InputDecoration(
                              labelText: "Year",
                              hintText: "(E.g. 2023)",
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 15.0,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide()),
                            ),
                            validator: (year) {
                              if (year?.isEmpty ?? true) {
                                return "Year cannot be empty";
                              }
                              if (int.parse(year!) < 2000 ||
                                  int.parse(year!) > 2025) {
                                return "Invalid year";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 60),
                        DropdownButton(
                          value: semesterSelected,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: semesters.map((String semester) {
                            return DropdownMenuItem(
                              value: semester,
                              child: Text(semester),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              semesterSelected = newValue!;
                            });
                            //print(semesterSelected);
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 35),
                    ElevatedButton(
                      onPressed: () async {
                        if (!(_formKey.currentState?.validate() ?? false)) {
                          // validation failed for some fields
                          return;
                        }
                        //TODO: implement the controller of the button
                        setState(() {
                          _isLoading = true;
                        });
                        upperCaseCourseCode = courseCode.toUpperCase();
                        upperCaseCourseCode = upperCaseCourseCode +
                            " " +
                            semesterSelected +
                            " " +
                            year;
                        try {
                          //------------dummy checking for the UI---------------
                          GroupMember dummyMember = GroupMember(
                              user:
                                  User(userId: "dummyId", username: "IAmDummy"),
                              role: Role.admin);
                          GroupChat dummyGroup = GroupChat(
                              id: "CourseCodeDummyID",
                              members: [dummyMember],
                              unread: 0,
                              createdAt: DateTime.now(),
                              name: upperCaseCourseCode);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ChatRoomScreenGroup(chatroom: dummyGroup)));

                          //------------dummy checking for the UI---------------
                        } on ApiException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("error: ${e.message}")));
                        } finally {
                          //remove loading screen
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      child: const Text(
                        "Join",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              )));
}
