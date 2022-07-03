import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:pdf_text/pdf_text.dart';

class PdfService {
  String? _fileName;
  String? _text;
  File? _file;
  PDFDoc? _pdf;

  String? get fileName => _fileName;

  String? get text => _text;

  bool receivedFile() => _file != null;

  void clear() {
    _fileName = null;
    _text = null;
    _file = null;
    _pdf = null;
  }

  Future<void> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      _file = File(result.files.single.path!);
    }
    if (_file != null) {
      _pdf = await PDFDoc.fromFile(_file!);
      _text = (await _pdf?.text)!;
      _fileName = _file?.path.split('/').last;
    }
  }
}
