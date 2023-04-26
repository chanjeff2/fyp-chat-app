// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'need_update_keys_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NeedUpdateKeysDto _$NeedUpdateKeysDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['signedPreKey', 'oneTimeKeys'],
  );
  return NeedUpdateKeysDto(
    signedPreKey: json['signedPreKey'] as bool,
    oneTimeKeys: json['oneTimeKeys'] as bool,
  );
}

Map<String, dynamic> _$NeedUpdateKeysDtoToJson(NeedUpdateKeysDto instance) =>
    <String, dynamic>{
      'signedPreKey': instance.signedPreKey,
      'oneTimeKeys': instance.oneTimeKeys,
    };
