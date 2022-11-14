import 'package:flutter/material.dart';
import 'package:fyp_chat_app/dto/login_dto.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/network/account_api.dart';
import 'package:fyp_chat_app/network/api.dart';
import 'package:fyp_chat_app/storage/credential_store.dart';
import 'package:provider/provider.dart';

import '../../dto/access_token_dto.dart';
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
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isRegister = false;

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
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                enabled: _isRegister,
                decoration: InputDecoration(
                    labelText: "Confirm Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                      icon: _isConfirmPasswordVisible
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    )),
                validator: (confirmPassword) {
                  if (confirmPassword?.isEmpty ?? true) {
                    return "please enter your password again";
                  }
                  if (confirmPassword != password) {
                    return "please make sure your input is the same as the password";
                  }
                  return null;
                },
              ),
              Consumer<UserState>(
                builder: (context, userState, child) => ElevatedButton(
                  onPressed: () async {
                    if (!(_formKey.currentState?.validate() ?? false)) {
                      // validation failed for some fields
                      return;
                    }
                    try {
                      late final AccessTokenDto accessToken;
                      // login
                      accessToken = await AuthApi().login(
                        LoginDto(username: username, password: password),
                      );
                      // store credential
                      await CredentialStore()
                          .storeCredential(username, password);
                      await CredentialStore().storeToken(accessToken);
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
                  //add a nevigator to register page
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
