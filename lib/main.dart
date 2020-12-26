import 'package:flutter/material.dart';
import 'package:flutter_app_note/ui/views/login/auth_view.dart';
// import 'package:flutter_app_note/ui/views/login/login_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: LoginPage(),
      home: LoginView(),
    );
  }
}
