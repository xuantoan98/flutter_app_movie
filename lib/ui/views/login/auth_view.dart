import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_note/ui/views/login/auth_viewmodel.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final logo = Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
          tag: 'hero',
          child: SizedBox(
            height: 155.0,
            child: Image.asset('assets/logo01.png'),
          )),
    );

    return ViewModelBuilder<AuthViewModel>.reactive(
      // onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(title: Text("")),
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  logo,
                  TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      controller: model.email),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Mật khẩu',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    controller: model.password,
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ButtonTheme(
                    minWidth: 200,
                    height: 56,
                    child: RaisedButton(
                      child: Text('Đăng nhập',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: () => {
                        model.handleLogin(context),
                      },
                    ),
                  ),
                ],
              )
            ],
          )),
      viewModelBuilder: () => AuthViewModel(),
    );
  }
}
