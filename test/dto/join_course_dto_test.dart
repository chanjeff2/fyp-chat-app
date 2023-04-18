import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/join_course_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';

void main() {
  late final JoinCourseDto joinCourseDto;
  setUpAll(() {
    //setup
    joinCourseDto = JoinCourseDto(
      courseCode: "courseCode",
      year: "year",
      semester: Semester.Spring,
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = joinCourseDto.toJson();
    //de-serialize
    final receivedJoinCourseDto = JoinCourseDto.fromJson(json);
    //compare
    expect(receivedJoinCourseDto.courseCode, joinCourseDto.courseCode);
    expect(receivedJoinCourseDto.year, joinCourseDto.year);
    expect(receivedJoinCourseDto.semester, joinCourseDto.semester);
  });
}
