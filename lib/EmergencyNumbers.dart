import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';






class EmergencyPage extends StatefulWidget {
  @override
  _EmergencyPageState createState() => new _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {

  String number;


  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: true,
    isButtonVisible: false ,
    isOverlayTapDismiss: true,
    animationDuration: Duration(milliseconds: 400),
    backgroundColor: Colors.lightGreen,
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(
        width: 4,
        color: Colors.black54,
      ),
    ),
    titleStyle: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        color: Colors.black54
    ),
  );
  getNumber(String Number) async {
    String url = "https://wzb44b7qsc.execute-api.ap-south-1.amazonaws.com/production/getnumber";


    var bod = {

      'number': Number,
    };
    String bo = json.encode(bod);


    print(bo);

    var res = await http.post(url, body: bo);
    print(res.body);
    try {

      if (res.statusCode == 200) {

        Map<String, dynamic> map=json.decode(res.body);
        number=map['body'];
        print(map['body']);

      }
    }
    catch(e){
      print (e);
      Alert(context: context, title: "Something went Wrong Try Again ",style: alertStyle).show();
    }
  }
  _callNumber1() async{
    await getNumber("number1");
    bool res = await FlutterPhoneDirectCaller.callNumber(number);
  }
  _callNumber2() async{
    await getNumber("number2");
    bool res = await FlutterPhoneDirectCaller.callNumber(number);
  }
  _callNumber3() async{
    await getNumber("number3");
    bool res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Emergency Numbers",style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'),),

        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Container(
                padding: EdgeInsets.only(top: 130.0, left: 70.0, right: 70.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 40.0),
                    Container(
                      
                      height: 60.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          child: Row(
                            children: <Widget>[

                              Container(
                                child: Text(
                                  "Number 1",
                                  style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                              Expanded(child: Container(
                                padding: EdgeInsets.only( right: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(

                                      Icons.call,
                                      color: Colors.white,
                                    ),
                                  )
                              ),)

                            ],
                          ),
                          splashColor: Colors.lightGreen,
                          onPressed: () {
                            _callNumber1();


                          },

                        ),


                      ),
                    ),


                  ],
                )),
            SizedBox(height: 1.0),
            Container(
                padding: EdgeInsets.only(top: 0.0, left: 70.0, right: 70.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 40.0),
                    Container(

                      height: 60.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          child: Row(
                            children: <Widget>[

                              Container(
                                child: Text(
                                  "Number 2",
                                  style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                              Expanded(child: Container(
                                  padding: EdgeInsets.only( right: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(

                                      Icons.call,
                                      color: Colors.white,
                                    ),
                                  )
                              ),)

                            ],
                          ),
                          splashColor: Colors.lightGreen,
                          onPressed: () {
                            _callNumber2();


                          },

                        ),


                      ),
                    ),


                  ],
                )),
            SizedBox(height: 1.0),
            Container(
                padding: EdgeInsets.only(top: 0.0, left: 70.0, right: 70.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 40.0),
                    Container(

                      height: 60.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          child: Row(
                            children: <Widget>[

                              Container(
                                child: Text(
                                  "Number 3",
                                  style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                              Expanded(child: Container(
                                  padding: EdgeInsets.only( right: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(

                                      Icons.call,
                                      color: Colors.white,
                                    ),
                                  )
                              ),)

                            ],
                          ),
                          splashColor: Colors.lightGreen,
                          onPressed: () {
                            _callNumber3();


                          },

                        ),


                      ),
                    ),


                  ],
                )),

          ],
        ));
  }


}
