import 'package:fyp_chat_app/dto/group_dto.dart';
import 'package:fyp_chat_app/dto/join_course_dto.dart';
import 'package:fyp_chat_app/models/group_chat.dart';

import 'api.dart';

class CourseGroupApi extends Api {
  CourseGroupApi._();
  static final CourseGroupApi _instance = CourseGroupApi._();
  factory CourseGroupApi() {
    return _instance;
  }

  @override
  String pathPrefix = "/course";

  Future<GroupChat> joinCourse(
      String courseCode, String year, Semester semester) async {
    try {
      final JoinCourseDto dto =
          JoinCourseDto(courseCode: courseCode, year: year, semester: semester);
      final json = await post("/join", body: dto.toJson(), useAuth: true);
      final returnDto = GroupDto.fromJson(json);
      return GroupChat.fromDto(returnDto);
    } catch (e) {
      throw e;
    }
  }
}
