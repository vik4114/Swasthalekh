import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'dart:math' as math show pi;



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  @override
  void initState(){
    _items = _generateItems;
    _headline = _items.firstWhere((item) => item.isSelected).text;
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sidebar ui',
        home: Scaffold(
          body: HomePage(),
        ),
      );
    }
  }



  List<CollapsibleItem> _items;
  String _headline;
  NetworkImage _avatarImg =
  NetworkImage('https://www.w3schools.com/howto/img_avatar.png');



  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
        text: 'Dashboard',

        icon: Icons.assessment,
        onPressed: () => setState(() => _headline = 'DashBoard'),
        isSelected: true,
      ),


      CollapsibleItem(
        text: 'Log Out',
        icon: Icons.logout,
        onPressed:()=> _body(context),
      ),

    ];
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.green,
      child: SafeArea(
          child: Center(
            child: CollapsibleSidebar(
              items: _items,
              avatarImg: _avatarImg,
              title: 'John Smith',
              height: double.infinity,
              body: _body(context),
              backgroundColor: Colors.white,
              unselectedIconColor: Colors.green,
              selectedIconColor: Colors.white,
              selectedIconBox: Colors.green,
              textStyle: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 15, fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
              titleStyle: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
              toggleTitleStyle: TextStyle(decoration: TextDecoration.none,fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
      ),
    );
  }

  Widget _body( BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(12.0, 110.0, 0.0, 0.0),
                    child: Text('Hello',
                        style: TextStyle(
                            fontSize: 70.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(13.0, 175.0, 0.0, 0.0),
                    child: Text('There',
                        style: TextStyle(
                            fontSize: 70.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                  padding: EdgeInsets.fromLTRB(193.0, 175.0, 0.0, 0.0),
                  child: Text('.',
                  style: TextStyle(
                  fontSize: 70.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
                  )

                ],

              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[

                    SizedBox(height: 40.0),
                    Container(
                      height: 50.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Center(
                            child: Text(
                              'SCAN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50.0),
                    Container(
                      height: 50.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Center(
                            child: Text(
                              'SHOW',
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

          ],
        ));


  }


}
