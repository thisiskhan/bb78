import 'package:boysbrigade/components/alertbox.dart';
import 'package:boysbrigade/components/loader.dart';
import 'package:boysbrigade/controller/firebase_auth.dart';
import 'package:boysbrigade/controller/logger_controller.dart';
import 'package:boysbrigade/pages/home.dart';
import 'package:boysbrigade/pages/settings.dart';
import 'package:boysbrigade/provider/auth_prodiver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:progress_dialog/progress_dialog.dart';

final _firestore = FirebaseFirestore.instance;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldFormKey =
      new GlobalKey<ScaffoldState>();
  ProgressDialog pr;
  Authentication auth = Authentication();
  AuthService authService = AuthService();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.i('Login Initialize');
    pr = ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      key: _scaffoldFormKey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 50, 40, 0),
          child: Form(
            key: _loginFormKey,
            child: ListView(
              children: <Widget>[
                Image.asset(
                  'assets/logo.png',
                  height: 200,
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    fillColor: Colors.white,
                    hintText: 'email',
                    filled: true,
                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                  ),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'email';
                    } else if (!EmailValidator.validate(value)) {
                      return 'email';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'pass',
                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                  ),
                  controller: _passwordController,
                  obscureText: true,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'pass';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                RaisedButton(
                  child: Text(
                    'login',
                    style: TextStyle(fontSize: 16),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Colors.blueGrey[900],
                  textColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20.0),
                  onPressed: () async {
                    if (_loginFormKey.currentState.validate()) {
                      ///[newcode] below is the updated version for firebase auth
                      pr.show();
                      auth
                          .signInUser(
                              scaffoldKey: _scaffoldFormKey,
                              context: context,
                              email: _emailController.text,
                              password: _passwordController.text)
                          .whenComplete(() {
                        pr.hide();
                      });
                      ///[oldcode] below is the old auth firebase code
                      //   Loader.showLoadingScreen(context, _keyLoader);

                      //   await authService.signIn(
                      //       _emailController.text, _passwordController.text);

                      //   Navigator.of(_keyLoader.currentContext,
                      //           rootNavigator: true)
                      //       .pop();

                      //   int statusCode = authService.statusCode;
                      //   print(statusCode);
                      //   if (statusCode == 200) {
                      //     Navigator.pushReplacement(context,
                      //         MaterialPageRoute(builder: (context) => Home()));
                      //   }
                      //   if (statusCode != null && statusCode != 200) {
                      //     print(statusCode);

                      //     print(authService.msg);

                      //     AlertBox alertBox = AlertBox(authService.msg);
                      //     return showDialog(
                      //         context: context,
                      //         builder: (BuildContext context) {
                      //           return alertBox.build(context);
                      //         });
                      //   }
                    }
                    //getCurrentUser();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
