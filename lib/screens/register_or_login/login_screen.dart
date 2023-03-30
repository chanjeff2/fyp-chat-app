// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:fyp_chat_app/dto/login_dto.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/network/account_api.dart';
import 'package:fyp_chat_app/network/api.dart';
import 'package:fyp_chat_app/screens/register_or_login/register_screen.dart';
import 'package:fyp_chat_app/storage/credential_store.dart';
import 'package:provider/provider.dart';

import '../../dto/register_dto.dart';
import '../../network/auth_api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  String get username => _usernameController.text;
  String get password => _passwordController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                    labelText: "Username",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                    border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(10.0)),
                        borderSide: BorderSide())),
                validator: (username) {
                  if (username?.isEmpty ?? true) {
                    return "username cannot be empty";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                    labelText: "Password",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 15.0),
                    // ignore: prefer_const_constructors
                    border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        borderSide: const BorderSide()),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: _isPasswordVisible
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    )),
                validator: (password) {
                  if (password?.isEmpty ?? true) {
                    return "password cannot be empty";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Consumer<UserState>(
                builder: (context, userState, child) => ElevatedButton(
                  onPressed: () async {
                    if (!(_formKey.currentState?.validate() ?? false)) {
                      // validation failed for some fields
                      return;
                    }
                    try {
                      // login
                      await AuthApi().login(
                        LoginDto(username: username, password: password),
                      );
                      Provider.of<UserState>(context, listen: false)
                          .setAccessTokenStatus(true);
                      // get account profile
                      final account = await AccountApi().getMe();
                      userState.setMe(account);
                    } on ApiException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("error: ${e.message}")));
                    }
                  },
                  child: const Text("Login"),
                ),
              ),
              TextButton(
                onPressed: () {
                  //Negivate to Register screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: Text.rich(TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
