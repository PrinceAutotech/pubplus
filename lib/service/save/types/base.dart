import 'dart:typed_data';

abstract class BaseSave {
  Future<void> saveFile(Uint8List bytes, String filename) {
    throw UnimplementedError('savePDF has not been implemented.');
  }
}
