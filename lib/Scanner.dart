import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;
import 'package:images_to_pdf/images_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class Scanner extends StatefulWidget {
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  File _pdfFile;
  String _status = "Not created";
  FileStat _pdfStat;
  bool _generating = false;
  List<File> files;

  String fileName = '';
  Future filepicker(BuildContext context) async {
    try {
       files = await FilePicker.getMultiFile();
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sorry...'),
              content: Text('Unsupported exception: $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
    await _createPdf();
  }

  Future<void> _createPdf() async {
    try {
      final doc = pw.Document();
      this.setState(() => _generating = true);
      final tempDir = await getApplicationDocumentsDirectory();
      final output = File(path.join(tempDir.path, 'example.pdf'));

      print('file name' '$output');

      this.setState(() => _status = 'Preparing images...');

      final images1 = await files;
      print(images1);
      this.setState(() => _status = 'Generating PDF');
      await ImagesToPdf.createPdf(
        pages: images1
            .map(
              (file) => PdfPage(
                imageFile: file,
                size: Size(1920, 1080),
                compressionQuality: 0.5,
              ),
            )
            .toList(),
        output: output,
      );
      _pdfStat = await output.stat();
      output.writeAsBytesSync(doc.save());
      this.setState(() {
        _pdfFile = output;
        _status = 'PDF Generated (${_pdfStat.size ~/ 1024}kb)';
      });
    } catch (e) {
      this.setState(() => _status = 'Failed to generate pdf: $e".');
      print('$e');
    } finally {
      this.setState(() => _generating = false);
    }
  }

  Future<void> _openPdf() async {
    if (_pdfFile != null) {
      try {
        final bytes = await _pdfFile.readAsBytes();
        await Printing.sharePdf(
            bytes: bytes, filename: path.basename(_pdfFile.path));
      } catch (e) {
        _status = 'Failed to open pdf: $e".';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _generating;
    return Scaffold(
      appBar: AppBar(
        title: Text(_status),
      ),
      body: Column(
        children: <Widget>[
          if (isLoading) CircularProgressIndicator(),
          if (!isLoading) ...[
            if (_pdfFile == null)
              RaisedButton(
                child: Text("Generate PDF"),
                onPressed: () {
                  filepicker(context);
                },
              ),
            if (_pdfFile != null)
              RaisedButton(
                child: Text("Open PDF"),
                onPressed: _openPdf,
              ),
          ]
        ],
      ),
    );
  }
}
