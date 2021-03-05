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
        text: 'Profile',
        icon: Icons.person,
        onPressed: () => setState(() => _headline = 'Settings'),
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
    return new Scaffold();

  }


}
