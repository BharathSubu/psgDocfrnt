import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';

import '../../utils/class_builder.dart';
import '../screens2/auth_page.dart';
import '../screens2/patients.dart';
import '../screens2/profile/profile.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ClassBuilder.registerClasses();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatefulWidget {
  MainWidget({Key? key}) : super(key: key);

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> with TickerProviderStateMixin {
  late KFDrawerController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = KFDrawerController(
      initialPage: ClassBuilder.fromString('Profile'),
      items: [
        KFDrawerItem.initWithPage(
          text: Text('PROFILE', style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.person, color: Colors.white),
          page: Profile(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'YOUR PATIENTS',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.group, color: Colors.white),
          page: CalendarPage(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'SETTINGS',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.settings, color: Colors.white),
          page: ClassBuilder.fromString('SettingsPage'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KFDrawer(
        borderRadius: 20.0,
        shadowBorderRadius: 20.0,
        menuPadding: EdgeInsets.only(left: 20.0),
        scrollable: true,
        controller: _drawerController,
        header: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.only(bottom: 80.0),
            width: MediaQuery.of(context).size.width * 0.6,
            child: Image.asset(
              'assets/images/logo.png',
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        footer: KFDrawerItem(
          text: Text(
            'LOG OUT',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(
            Icons.input,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) {
                return AuthPage();
              },
            ));
          },
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 255, 255, 1.0),
              Color.fromRGBO(44, 72, 171, 1.0)
            ],
            tileMode: TileMode.repeated,
          ),
        ),
      ),
    );
  }
}
