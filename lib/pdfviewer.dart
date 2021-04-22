import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:swasthalekh/show.dart';


class PdfViewerPage extends StatefulWidget {
  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String _url="";

  @override
  void initState() {
    geturl().then(updateUrl);
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Viewer",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: PDF.network(_url)
      )
    );
  }
  void updateUrl(String url) {
    setState(() {
      this._url=url;
    });
  }
}
