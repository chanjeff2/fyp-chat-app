import 'package:flutter/material.dart';
import 'package:fyp_chat_app/dto/account_dto.dart';
import 'package:fyp_chat_app/dto/login_dto.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/network/api.dart';
import 'package:fyp_chat_app/storage/credential_store.dart';
import 'package:provider/provider.dart';

import '../../dto/register_dto.dart';
import '../../network/auth_api.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
        title: const Text("Register"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (username) {
                  if (username?.isEmpty ?? true) {
                    return "username cannot be empty";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                    labelText: "Password",
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
              Consumer<UserState>(
                builder: (context, userState, child) => TextButton(
                  onPressed: () async {
                    if (!(_formKey.currentState?.validate() ?? false)) {
                      // validation failed for some fields
                      return;
                    }
                    try {
                      // register
                      final account = await AuthApi().register(
                        RegisterDto(
                          username: username,
                          password: password,
                        ),
                      );
                      Provider.of<UserState>(context, listen: false)
                          .setMe(account);
                      // login
                      final accessToken = await AuthApi().login(
                        LoginDto(username: username, password: password),
                      );
                      // store credential
                      await CredentialStore()
                          .storeCredential(username, password);
                      await CredentialStore()
                          .storeToken(accessToken.accessToken);
                      userState.setAccessTokenStatus(true);
                    } on ApiException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("error: ${e.message}")));
                    }
                  },
                  child: const Text("Register"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
