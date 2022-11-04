import 'package:flutter/material.dart';

import '../../models/create_user_dto.dart';
import '../../models/pre_key.dart';
import '../../network/users_api.dart';
import '../../signal/signal_client.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _usernameController = TextEditingController();

  Future<void> register() async {
    // register
    final createUserDto = CreateUserDto(
      username: "username",
      registrationId: SignalClient().registrationId,
      identityKey: SignalClient().identityKeyPair.getPublicKey(),
      signedPreKey:
          SignedPreKey.fromSignedPreKeyRecord(SignalClient().signedPreKey)
              .toDto(),
      oneTimeKeys: SignalClient()
          .preKeys
          .map((e) => PreKey.fromPreKeyRecord(e).toDto())
          .toList(),
    );
    await UsersApi().registerUser(createUserDto);
  }

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
              TextButton(
                onPressed: () async {
                  if (!(_formKey.currentState?.validate() ?? false)) {
                    // validation failed for some fields
                    return;
                  }
                  // TODO: register
                  try {
                    register();
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                child: const Text("Register"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
