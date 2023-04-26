// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_course_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinCourseDto _$JoinCourseDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['courseCode', 'year', 'semester'],
  );
  return JoinCourseDto(
    courseCode: json['courseCode'] as String,
    year: json['year'] as String,
    semester: $enumDecode(_$SemesterEnumMap, json['semester']),
  );
}

Map<String, dynamic> _$JoinCourseDtoToJson(JoinCourseDto instance) =>
    <String, dynamic>{
      'courseCode': instance.courseCode,
      'year': instance.year,
      'semester': _$SemesterEnumMap[instance.semester]!,
    };

const _$SemesterEnumMap = {
  Semester.Fall: 'Fall',
  Semester.Winter: 'Winter',
  Semester.Spring: 'Spring',
  Semester.Summer: 'Summer',
};
