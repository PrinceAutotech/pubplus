import 'package:image_picker/image_picker.dart';

class Campaign {
  String? title;
  String? heading;
  String? desc;
  final XFile imageFile;

  Campaign({
    this.title,
    this.heading,
    this.desc,
    required this.imageFile,
  });

  @override
  String toString() =>
      '{\n\ttitle: $title\n\theading: $heading\n\tdesc: $desc\n\timageFile: ${imageFile.path}\n}';
}
