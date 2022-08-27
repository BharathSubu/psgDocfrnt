import 'package:docfrnt/screens/auth/home.dart';
import 'package:docfrnt/screens/auth/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = WelcomeScreen();
  final storage = FlutterSecureStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String? token = await storage.read(key: "token");
    if (token != null) {
      setState(() {
        page = Home();
      });
    } else {
      setState(() {
        page = WelcomeScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: page,
    );
  }
}
