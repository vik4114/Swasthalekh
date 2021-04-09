import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:swasthalekh/home.dart';

import 'signup.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage()
      },
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
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

  login() async {
    String url = "https://gerf8iqdzg.execute-api.ap-south-1.amazonaws.com/production/users/login";


    var bod = {

      'email': _email.text,
      'password': _password.text,
    };
    String bo = json.encode(bod);
    final pasname = new TextEditingController();
    final pasphone = new TextEditingController();

    print(bo);
    var jsonResponse;
    var res = await http.post(url, body: bo);
    print(res.body);
    try {
      if (res.statusCode == 200) {

        Map<String, dynamic> map=json.decode(res.body);
        pasname.text=map['name'];
        pasphone.text=map['phone'];

        print("Response Status: ${res.statusCode}");
        if (map['result']=="true") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(pasname: pasname.text,pasphone: pasphone.text,),));
        }
      } else {
        print("2");
        print("Response Status: ${res.statusCode}");
        print("Response body: ${res.body}");
        Alert(context: context, title: "Email Id Password Doesn't match",style: alertStyle ).show();
      }
    }
    catch(e){
      print (e);
      Alert(context: context, title: "Something went Wrong Try Again ",style: alertStyle).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 350,
                    width:350,
                    padding: EdgeInsets.fromLTRB(25.0, 50.0, 0.0, 0.0),
                    child: ImageIcon(AssetImage('assets/Logo.png')),
                  ),

                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _email,
                      decoration: InputDecoration(
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      controller: _password,
                      decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      obscureText: true,
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      alignment: Alignment(1.0, 0.0),
                      padding: EdgeInsets.only(top: 15.0, left: 20.0),
                      child: InkWell(
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {
                            if(_email.text!=''&&_password.text!='')
                            {
                              login();
                            }
                            else
                            {
                              Alert(context: context, title: "Please fill all details",style: alertStyle ).show();
                            }

                          },
                          child: Center(
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),

                  ],
                )),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'New User?',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/signup');
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
