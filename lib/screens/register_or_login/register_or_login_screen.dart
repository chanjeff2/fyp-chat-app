import 'package:flutter/material.dart';
import 'package:fyp_chat_app/dto/login_dto.dart';
import 'package:fyp_chat_app/models/access_token.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/network/account_api.dart';
import 'package:fyp_chat_app/network/api.dart';
import 'package:fyp_chat_app/screens/register_or_login/loading_screen.dart';
import 'package:fyp_chat_app/signal/signal_client.dart';
import 'package:fyp_chat_app/storage/credential_store.dart';
import 'package:provider/provider.dart';

import '../../dto/register_dto.dart';
import '../../network/auth_api.dart';

class RegisterOrLoginScreen extends StatefulWidget {
  const RegisterOrLoginScreen({Key? key}) : super(key: key);

  @override
  State<RegisterOrLoginScreen> createState() => _RegisterOrLoginScreenState();
}

class _RegisterOrLoginScreenState extends State<RegisterOrLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isRegister = false;
  bool _isLoading = false;

  String get username => _usernameController.text;
  String get password => _passwordController.text;

  @override
  Widget build(BuildContext context) => _isLoading
      ? const LoadingScreen()
      : Scaffold(
          appBar: AppBar(
            title: Text(_isRegister ? "Register" : "Login"),
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
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 15.0,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide()),
                    ),
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
                          vertical: 15.0,
                          horizontal: 15.0,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(),
                        ),
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
                  if (_isRegister)
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      enabled: _isRegister,
                      decoration: InputDecoration(
                          labelText: "Confirm Password",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 15.0),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide()),
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
                      validator: (username) {
                        if (username?.isEmpty ?? true) {
                          return "username cannot be empty";
                        }
                        return null;
                      },
                    ),
                  Consumer<UserState>(
                    builder: (_, userState, child) => ElevatedButton(
                      onPressed: () async {
                        if (!(_formKey.currentState?.validate() ?? false)) {
                          // validation failed for some fields
                          return;
                        }
                        //prop loading screen
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          late final AccessToken accessToken;
                          if (_isRegister) {
                            // register
                            accessToken = await AuthApi().register(
                              RegisterDto(
                                username: username,
                                password: password,
                              ),
                            );
                          } else {
                            // login
                            accessToken = await AuthApi().login(
                              LoginDto(username: username, password: password),
                            );
                          }
                          // init signal stuffs
                          await SignalClient().initialize();
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
                        } finally {
                          //remove loading screen
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      child: Text(_isRegister ? "Register" : "Login"),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isRegister = !_isRegister;
                      });
                    },
                    child: Text.rich(TextSpan(
                      text: _isRegister
                          ? "Already have an account? "
                          : "Don't have an account? ",
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: _isRegister ? "Login" : "Sign Up",
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
