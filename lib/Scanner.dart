
import 'dart:io';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:swasthalekh/form.dart';
import 'package:swasthalekh/home.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:swasthalekh/main.dart';
import 'package:loading_overlay/loading_overlay.dart';



class Scanner extends StatefulWidget {
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  String _fname="";
  String _prescription="";
  String _problem="";
  String _date="";
  bool visible = false ;



  String URL;
  String _phone="";
  final picker = ImagePicker();
  final pdf = pw.Document();
  List<File> _image = [];
  @override
  void initState(){
    getPhone().then(updatePhone);
    getfName().then(updatefname);
    getPresciption().then(updateprescription);
    getProblem().then(updateproblem);
    getDate().then(updatedate);
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }
  loadProgress() {
    setState(() {
      visible = true;
    });
  }

  _imgFromCamera() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      if (image != null) {
        _image.add(File(image.path));
      } else {
        print('No image selected');
      }
    });
  }

  _imgFromGallery() async {
    // ignore: deprecated_member_use
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      if (image != null) {
        _image.add(File(image.path));
      } else {
        print('No image selected');
      }
    });
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

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
              icon: Icon(Icons.save),
              onPressed: () {
                DateTime now = DateTime.now();
                String formattedDate = DateFormat('d_MMM_y_kk:mm:ss').format(now);
                if (_image.isNotEmpty) {
                  loadProgress();
                  createPDF();
                  savePDF(formattedDate);
                  uploadPdf(formattedDate);
                } else {
                  showPrintedMessage('error', 'Select Atleast One Image');
                }


              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add, ),
        onPressed:(){
          _showPicker(context);
          },
      ),
      body: LoadingOverlay(
        child: _image != null
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
        isLoading: visible,
      )

    );
  }

  getImageFromGallery() async {
    final image = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (image != null) {
        _image.add(File(image.path));
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
  void uploadPdf(String formattedDate) async{
      String pname;
      pname=_phone+'/'+formattedDate+'.pdf';
      String url = "https://xtn1wo17u8.execute-api.ap-south-1.amazonaws.com/production/url";

      var bod = {

        "name":pname,
      };
      String bo = json.encode(bod);



      print(bo);
      var res = await http.post(url, body: bo);
      var data1 = json.decode(res.body);

      print(data1['body']);
      final dir = await getExternalStorageDirectory();
      final file = File('${dir.path}/$formattedDate.pdf');
      String path =dir.path+'/'+formattedDate+'.pdf';
      print(file);
      var urlupload = data1['body'];

      var request = http.MultipartRequest('PUT', Uri.parse(urlupload));
      request.files.add(await MultipartFile.fromPath('content', path));
      var response = await request.send();
      var status = response.statusCode;
      if(status==200){
        saveForm(formattedDate);
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())); // ignore: missing_required_param
        showPrintedMessage('Sucess', 'Uploaded');
      }



  }
  void updatePhone(String phone) {
    setState(() {
      this._phone=phone;
    });
  }
  void saveForm(formattedDate) async{
    String pname;
    pname=_phone+'/'+formattedDate+'.pdf';
    String url = "https://7zm15xijab.execute-api.ap-south-1.amazonaws.com/production/form";


    var bod = {
      'pname': pname,
      'dname': _fname,
      'prescription': _prescription,
      'problem': _problem,
      'date':_date,
      "phone": _phone,
    };
    String bo = json.encode(bod);
    print(bo);

    var res = await http.post(url, body: bo);
    print(res.body);

  }

  void updatefname(String fname) {
    setState(() {
      this._fname=fname;
    });
  }
  void updateproblem(String problem) {
    setState(() {
      this._problem=problem;
    });
  }
  void updateprescription(String prescription) {
    setState(() {
      this._prescription=prescription;
    });
  }
  void updatedate(String date) {
    setState(() {
      this._date=date;
    });
  }
}



