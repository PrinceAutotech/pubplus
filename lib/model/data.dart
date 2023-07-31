import 'dart:io';

class Data {
  String? title;
  String? heading;
  String? desc;
  final File imageFile;

  Data({
    this.title,
    this.heading,
    this.desc,
    required this.imageFile,
  });
  @override
  String toString() {
    return '{\n\ttitle: $title\n\theading: $heading\n\tdesc: $desc\n\timageFile: ${imageFile.path}\n}';
  }
}
