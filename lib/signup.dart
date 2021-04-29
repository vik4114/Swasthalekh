import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:swasthalekh/main.dart';



class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _pnumber = TextEditingController();


  String dob;
  signUp() async {
    String url = "https://gerf8iqdzg.execute-api.ap-south-1.amazonaws.com/production/users/signup";


    var bod = {

        'email': _email.text,
        'password': _password.text,
        'phone': _pnumber.text,
         'name' : _name.text,
        'dob' : dob,
    };
    String bo = json.encode(bod);

    print(bo);
    var res = await http.post(url, body: bo);
    print(res.body);
    try {
      if (res.statusCode == 200) {
        if(res.body.isNotEmpty) {
          json.decode(res.body);
        }
        print("Response Status: ${res.statusCode}");

        print("Response body: ${res.body}");

        if (res != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
          );
          showPrintedMessage('Success', 'Please Log in');
        }
      } else {
        print("2");
        print("Response Status: ${res.statusCode}");
        print("Response body: ${res.body}");
        showPrintedMessage('Failed', 'Email Id Password Already present');

      }
    }
    catch(e){
      print (e);
      showPrintedMessage('Failed', 'Something went Wrong Try Again');

    }
  }


  DateTime currentDate = DateTime.now();
  DateFormat formatter = DateFormat.yMMMd();
  Future<void> _selectDate(BuildContext context) async {
  bool _decideWhichDayToEnable(DateTime day) {
      if ((day.isBefore(DateTime.now().add(Duration(days: 0))))) {
        return true;
      }
      return false;
  }
  final DateTime pickedDate = await showDatePicker(
  context: context,
  initialDate: currentDate,
  firstDate: DateTime(1900),
  selectableDayPredicate: _decideWhichDayToEnable,
  lastDate: (DateTime.now().add(Duration(days: 3650))));
  if (pickedDate != null && pickedDate != currentDate)
  setState(() {
  currentDate = pickedDate;
  });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 50.0, 0.0, 0.0),
                  child: Text(
                    'Signup',
                    style:
                    TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(260.0, 65.0, 0.0, 0.0),
                  child: Text(
                    '.',
                    style: TextStyle(
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                )
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
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
                        // hintText: 'EMAIL',
                        // hintStyle: ,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: _password,
                    decoration: InputDecoration(
                        labelText: 'PASSWORD ',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    obscureText: true,
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    inputFormatters: [ FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")), ],
                    controller: _name,
                    decoration: InputDecoration(
                        labelText: 'NAME',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                  ),
                  SizedBox(height: 10.0),
                  Container(

                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width:304,
                          child:TextField(
                            enabled: false,
                            decoration: InputDecoration(
                                hintText: currentDate.toString(),
                                labelText: 'DOB   '+(formatter.format(currentDate)),
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green))),
                          ),

                        ),
                        Container(
                          child: IconButton(
                            onPressed: () => _selectDate(context),
                            icon: Icon(Icons.calendar_today,color: Colors.green,),
                          ),

                        ),

                      ],
                    ),

                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    inputFormatters: [ FilteringTextInputFormatter.allow(RegExp("[0-9 ]")), ],
                    controller: _pnumber,
                    decoration: InputDecoration(
                        labelText: 'PHONE NO. ',
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
                        child: FlatButton( // ignore: deprecated_member_use
                          splashColor: Colors.lightGreen,
                          onPressed: () {
                            DateFormat formd = DateFormat.d();
                            DateFormat formm = DateFormat.M();
                            DateFormat formy = DateFormat.y();

                            String day = formd.format(currentDate);
                            String mon = formm.format(currentDate);
                            String yea = formy.format(currentDate);
                            dob = day+'-'+mon+'-'+yea ;
                            print(dob);
                            if((_email.text).contains('@')==true&&(_email.text).contains('.')==true)
                              {

                                if((_password.text).contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))&&(_password.text).contains(new RegExp(r'[0-9]'))){
                                  if((_password.text).length>=8)
                                    {
                                      if(_email.text!=''&&_password.text!=''&&_name.text!=''&&_pnumber.text!='')
                                      {
                                        signUp();
                                      }
                                      else
                                      {
                                        showPrintedMessage('Error', 'Please fill all details');
                                      }
                                    }
                                  else
                                    {
                                      showPrintedMessage('Error', 'Password must be 8 or more characters');
                                    }

                                }
                                else
                                  {
                                    showPrintedMessage('Error', 'Password must contain atleast one special character and one number');
                                  }
                              }
                            else
                              {
                                showPrintedMessage('Error', 'Email is not correct');
                              }




                          },
                          child: Center(
                            child: Text(
                              'SIGNUP',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(height: 20.0),
                  Container(
                    height: 40.0,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1.0),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child:

                        Center(
                          child: Text('Go Back',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat')),
                        ),


                      ),
                    ),
                  ),
                ],
              )),

        ]));
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
