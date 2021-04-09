import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:swasthalekh/home.dart';



class Scanner extends StatefulWidget {
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final picker = ImagePicker();
  final pdf = pw.Document();
  List<File> _image = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Scan",style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat'),),
        actions: [
          IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () {
                DateTime now = DateTime.now();
                String formattedDate = DateFormat('d MMM y kk:mm:ss').format(now);
                createPDF();
                savePDF(formattedDate);
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add, ),
        onPressed: getImageFromGallery,
      ),
      body: _image != null
          ? ListView.builder(
        itemCount: _image.length,
        itemBuilder: (context, index) => Container(
            height: 400,
            width: double.infinity,
            margin: EdgeInsets.all(8),
            child: Image.file(
              _image[index],
              fit: BoxFit.cover,
            )),
      )
          : Container(),
    );
  }

  getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });
  }

  createPDF() async {
    for (var img in _image) {
      final image = pw.MemoryImage(img.readAsBytesSync());

      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context contex) {
            return pw.Center(child: pw.Image(image));
          }));
    }
  }

  savePDF(String formattedDate) async {
    try {
      final dir = await getExternalStorageDirectory();
      final file = File('${dir.path}/$formattedDate.pdf');
      await file.writeAsBytes(await pdf.save());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      showPrintedMessage('Success', 'Saved to documents');

    } catch (e) {
      showPrintedMessage('error', e.toString());
    }
  }

  showPrintedMessage(String title, String msg) {
    Flushbar(
      title: title,
      message: msg,
      duration: Duration(seconds: 3),
      icon: Icon(
        Icons.info,
        color: Colors.green,
      ),
    )..show(context);
  }
}