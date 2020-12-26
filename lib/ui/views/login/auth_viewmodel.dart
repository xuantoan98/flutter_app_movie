import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app_note/ui/views/login/login_view.dart';
import 'package:flutter_app_note/ui/views/note/note_view.dart';
import 'auth_model.dart';

class AuthViewModel extends BaseViewModel {
  var email = TextEditingController();
  var password = TextEditingController();

  static Auth userCurrent;

  void handleLogin(context) {
    if (email.text == "admin@gmail.com" && password.text == "1") {
      userCurrent = Auth(email.text, password.text);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NoteView()),
      );
    } else {
      print("Login False");
    }
  }

  static void handleLogout(context) {
    userCurrent = null;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
