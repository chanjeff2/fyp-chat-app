import 'package:json_annotation/json_annotation.dart';

part 'send_invitation_dto.g.dart';

@JsonSerializable()
class SendInvitationDto {
  @JsonKey(required: true)
  final String target;

  @JsonKey(required: true)
  final String sentAt; // iso string

  SendInvitationDto({
    required this.target,
    required this.sentAt,
  });

  Map<String, dynamic> toJson() => _$SendInvitationDtoToJson(this);

  factory SendInvitationDto.fromJson(Map<String, dynamic> json) =>
      _$SendInvitationDtoFromJson(json);
}
