import 'dart:typed_data';
import 'dart:html';

import 'base.dart';

class Save extends BaseSave {

  @override
  Future<void> saveFile(Uint8List bytes, String filename) async {
    final blob = Blob([bytes]);
    final url = Url.createObjectUrlFromBlob(blob);

    final anchor = document.createElement('a') as AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = filename;
    anchor.click();
  }
}
