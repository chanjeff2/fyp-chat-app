import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/file_dto.dart';

void main() {
  late final FileDto fileDto;
  setUpAll(() {
    //setup
    fileDto = FileDto(
      fileId: 'fileId',
      name: 'name',
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = fileDto.toJson();
    //de-serialize
    final receivedFileDto = FileDto.fromJson(json);
    //compare
    expect(receivedFileDto.fileId, fileDto.fileId);
    expect(receivedFileDto.name, fileDto.name);
  });
}
