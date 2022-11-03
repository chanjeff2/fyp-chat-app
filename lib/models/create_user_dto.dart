import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fyp_chat_app/models/pre_key_dto.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class CreateUserDto {
  String username;
  int registrationId;
  String? displayName;
  IdentityKey identityKey;
  SignedPreKeyDto signedPreKey;
  List<PreKeyDto> oneTimeKeys;

  CreateUserDto({
    required this.username,
    required this.registrationId,
    this.displayName,
    required this.identityKey,
    required this.signedPreKey,
    required this.oneTimeKeys,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["username"] = username;
    json["registrationId"] = registrationId;
    json["displayName"] = displayName;
    json["identityKey"] = base64.encode(identityKey.serialize());
    json["signedPreKey"] = signedPreKey.toJson();
    json["oneTimeKeys"] = oneTimeKeys.map((e) => e.toJson()).toList();
    return json;
  }
}
