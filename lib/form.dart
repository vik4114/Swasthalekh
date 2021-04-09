import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:swasthalekh/Scanner.dart';



class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }
  final TextEditingController _doctor = TextEditingController();
  final TextEditingController _problem = TextEditingController();
  final TextEditingController _prescription = TextEditingController();

  String date ;




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
        resizeToAvoidBottomPadding: false,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                  child: Text(
                    'Details',
                    style:
                    TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
                  ),
                ),

              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _doctor,
                    decoration: InputDecoration(
                        labelText: 'Doctor Name',
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
                                labelText: 'Date   '+(formatter.format(currentDate)),
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
                    controller: _problem,
                    decoration: InputDecoration(
                        labelText: 'Problem',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: _prescription,
                    decoration: InputDecoration(
                        labelText: 'Prescription',
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
                        child: GestureDetector(
                          onTap: () {
                            String day = DateFormat('dd').format(currentDate);
                            String mon = DateFormat('mm').format(currentDate);
                            String yea = DateFormat('y').format(currentDate);

                            date = day+'-'+mon+'-'+yea ;
                            print(date);

                            if(_doctor.text!=''&&_problem!=''&&_prescription!='')
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Scanner()),
                              );
                            }
                            else
                            {
                              showPrintedMessage('Error', 'Please fill all details');
                            }


                          },
                          child: Center(
                            child: Text(
                              'Proceed',
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
