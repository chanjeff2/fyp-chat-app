import 'package:json_annotation/json_annotation.dart';

part 'join_course_dto.g.dart';

@JsonSerializable()
class JoinCourseDto {
  @JsonKey(required: true)
  String courseCode;
  @JsonKey(required: true)
  String year;
  @JsonKey(required: true)
  Semester semester;

  JoinCourseDto(
      {required this.courseCode, required this.year, required this.semester});

  Map<String, dynamic> toJson() => _$JoinCourseDtoToJson(this);

  factory JoinCourseDto.fromJson(Map<String, dynamic> json) =>
      _$JoinCourseDtoFromJson(json);
}

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.pascal)
enum Semester {
  Fall,
  Winter,
  Spring,
  Summer,
}
