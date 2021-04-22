import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flushbar/flushbar.dart';


import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import 'package:swasthalekh/main.dart';


import 'package:loading_overlay/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';





class Showpage extends StatefulWidget {
  @override
  _ShowPage createState() => new _ShowPage();
}

class _ShowPage extends State<Showpage> {
  String urlupload;
  List rdname=[];
  List rdate=[];
  List rpname=[];

  var res;
  bool visible = false ;
  bool fvisible = false ;

  loadProgress(){


      setState(() {
        visible = true;
      });


  }
  loadlProgress(){


    setState(() {
      fvisible = true;
    });


  }
  final TextEditingController _query = TextEditingController();
  String _myActivity;

  final formKey = new GlobalKey<FormState>();
  @override
  void initState(){
    getPhone().then(updatePhone);
    super.initState();
    _myActivity = '';
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }



  Map data;
  List userData;
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Search",style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'),),

        ),
      body:LoadingOverlay(
        child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          elevation: 7.0,
                          child: Center(
                            child: DropDownFormField(

                              titleText: 'Search',
                              hintText: 'Please choose one',
                              value: _myActivity,
                              onSaved: (value) {
                                setState(() {
                                  _myActivity = value;
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  _myActivity = value;
                                });
                              },
                              dataSource: [
                                {
                                  "display": "Doctor Name",
                                  "value": "Doctor Name",
                                },
                                {
                                  "display": "Date (dd-mm-yyyy)",
                                  "value": "Date",
                                },
                                {
                                  "display": "Problem",
                                  "value": "Problem",
                                },
                                {
                                  "display": "Prescription",
                                  "value": "Prescription",
                                },
                                {
                                  "display": "All (No need Of Query)",
                                  "value": "All",
                                },

                              ],
                              textField: 'display',
                              valueField: 'value',
                            ),
                          ),
                        ),

                      ),

                    ],
                  ),

                ),
                Container(
                  padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _query,
                        decoration: InputDecoration(
                            labelText: 'Query',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(height: 50.0),
                      Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.greenAccent,
                            color: Colors.green,
                            elevation: 7.0,
                            // ignore: deprecated_member_use
                            child: FlatButton(
                              splashColor: Colors.lightGreen,
                              onPressed: () {
                                print("start");


                                if(_myActivity=="Doctor Name")
                                {
                                  print("gone");
                                  print(_query.text);

                                  if(_query.text!="")
                                    {
                                      loadProgress();
                                      doctorquery();
                                    }
                                  else
                                    {
                                      showPrintedMessage('Error', 'Please fill the Query');
                                    }

                                }
                                else if(_myActivity=="Date")
                                {
                                  if(_query.text!="")
                                  {
                                    loadProgress();
                                    datequery();

                                  }
                                  else
                                  {
                                    showPrintedMessage('Error', 'Please fill all Query');
                                  }

                                }
                                else if(_myActivity=="Problem")
                                {
                                  if(_query.text!="")
                                  {
                                    loadProgress();
                                    problemquery();
                                  }
                                  else
                                  {
                                    showPrintedMessage('Error', 'Please fill all Query');
                                  }


                                }
                                else if(_myActivity=="Prescription")
                                {
                                  if(_query.text!="")
                                  {
                                    loadProgress();
                                    prescriptionquery();

                                  }
                                  else
                                  {
                                    showPrintedMessage('Error', 'Please fill all Query');
                                  }


                                }
                                else if(_myActivity=="All")
                                {
                                  loadProgress();
                                  All();

                                }

                              },
                              child: Center(
                                child: Text(
                                  'Search',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          )),

                      Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: fvisible,
                          child: Container(
                              height: 420,
                              margin: EdgeInsets.only(top: 15, bottom: 10),
                              child: ListView.builder(itemBuilder: (Buildcontext,int index)
                              {
                                return Card(

                                  shadowColor: Colors.greenAccent,
                                  elevation: 10,
                                  color: Colors.green,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      children: [
                                        Expanded(child: Column(

                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  rdname[index],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Montserrat'),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  rdate[index],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Montserrat'),
                                                ),
                                              ],
                                            ),
                                          ],

                                        ),),
                                        Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: <Widget>[
                                                IconButton(
                                                  icon: const Icon(Icons.remove_red_eye),
                                                  color: Colors.white,
                                                  onPressed: ()  async {
                                                    await getUrl(rpname[index])
                                                        .whenComplete(() async {
                                                      await launch(urlupload);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],

                                        ),
                                      ],
                                    ),

                                  ),

                                );

                              },
                                itemCount: rdname==null?0:rdname.length,)
                          )
                      ),
                    ],
                  ),
                ),












              ]),


        ),
        isLoading: visible,
      ),



    );

  }
void datequery() async{
  String urlq="https://asrrndu6mb.execute-api.ap-south-1.amazonaws.com/production/date";
  var bod = {
    'query':_query.text,
    "phone": _phone,
  };
  String bo = json.encode(bod);
  var ares = await http.post(urlq, body: bo);

  Map<String, dynamic> map=json.decode(ares.body);
  rdname=map['body']['dname'];
  rdate=map['body']['date'];
  rpname=map['body']['pname'];
  if(ares.statusCode==200)
  {
    setState(() {
      visible = false;
    });
    loadlProgress();
  }
}
  void problemquery() async{
    String urlq="https://yxtfa7tuzc.execute-api.ap-south-1.amazonaws.com/production/problem";
    var bod = {
      'query':_query.text,
      "phone": _phone,
    };
    String bo = json.encode(bod);
    var ares = await http.post(urlq, body: bo);

    Map<String, dynamic> map=json.decode(ares.body);
    rdname=map['body']['dname'];
    rdate=map['body']['date'];
    rpname=map['body']['pname'];

    if(ares.statusCode==200)
    {
      setState(() {
        visible = false;
      });
      loadlProgress();
    }
  }
  void prescriptionquery() async{
    String urlq="https://p4p55g7zyi.execute-api.ap-south-1.amazonaws.com/production/prescription";
    var bod = {
      'query':_query.text,
      "phone": _phone,
    };
    String bo = json.encode(bod);
    var ares = await http.post(urlq, body: bo);

    Map<String, dynamic> map=json.decode(ares.body);
    rdname=map['body']['dname'];
    rdate=map['body']['date'];
    rpname=map['body']['pname'];
    if(ares.statusCode==200)
    {
      setState(() {
        visible = false;
      });
      loadlProgress();
    }

  }
  void All() async{
    String urlq="https://p4p55g7zyi.execute-api.ap-south-1.amazonaws.com/production/prescription";
    var bod = {
      'query':"",
      "phone": _phone,
    };
    String bo = json.encode(bod);
    var ares = await http.post(urlq, body: bo);

    Map<String, dynamic> map=json.decode(ares.body);
    rdname=map['body']['dname'];
    rdate=map['body']['date'];
    rpname=map['body']['pname'];
    if(ares.statusCode==200)
    {
      setState(() {
        visible = false;
      });
      loadlProgress();
    }

  }
  String _phone="";
  void updatePhone(String phone) {
    setState(() {
      this._phone=phone;
    });
  }

  void doctorquery() async{
    String urlq="https://tor70cepp1.execute-api.ap-south-1.amazonaws.com/production/doctor";
    var bod = {
      'query':_query.text,
      "phone": _phone,
    };
    String bo = json.encode(bod);
    var ares = await http.post(urlq, body: bo);

    Map<String, dynamic> map=json.decode(ares.body);
    rdname=map['body']['dname'];
    rdate=map['body']['date'];
    rpname=map['body']['pname'];
    if(ares.statusCode==200)
    {
      setState(() {
        visible = false;
      });
      loadlProgress();
    }

  }
  Future getUrl(String uril) async{
    String pname;
    pname=uril;
    String url = "https://pqvb9q6swe.execute-api.ap-south-1.amazonaws.com/production/retreiveurl";

    var bod = {

      "name":pname,
    };
    String bo = json.encode(bod);



    print(bo);
    var res = await http.post(url, body: bo);
    var data1 = json.decode(res.body);
    print(data1);



    urlupload = data1['body'];
    print(urlupload);
    saveurl(urlupload);




  }

}
Future<bool> saveurl(String url) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("url", url);
  // ignore: deprecated_member_use
  return prefs.commit();
}
Future<String> geturl() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String url = prefs.getString("url");
  return url;
}
