import 'package:boysbrigade/components/alertbox.dart';
import 'package:boysbrigade/components/loader.dart';
import 'package:boysbrigade/pages/home.dart';

import 'package:boysbrigade/provider/auth_prodiver.dart';
import "package:flutter/material.dart";

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _signupFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();
  AuthService authService = new AuthService();

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  @override
  int selectedRadioTile, selectedRadio;
  String group;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    selectedRadioTile = 0;
  }

  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  singUp() async {
    if (_signupFormKey.currentState.validate()) {
      Loader.showLoadingScreen(context, _keyLoader);

      await authService.signUp(
        _nameController.text,
        _passwordController.text,
        _emailController.text,
        group,
      );
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      int statusCode = authService.statusCode;

      print("StatusCode ****************** $statusCode");

      if (statusCode == 200) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        AlertBox alertBox = AlertBox(authService.msg);
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertBox.build(context);
            });
      }
    }

    // uploaduserprofile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 50, 40, 0),
          child: Form(
            key: _signupFormKey,
            child: ListView(
              children: <Widget>[
                Image.asset(
                  'assets/logo.png',
                  height: 200,
                ),
                SizedBox(
                  height: 30,
                ),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'name',
                      hintStyle:
                          TextStyle(fontSize: 16, color: Colors.grey[700]),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                    ),
                    controller: _nameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'email',
                      hintStyle:
                          TextStyle(fontSize: 16, color: Colors.grey[700]),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                    ),
                    controller: _emailController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'pass',
                      hintStyle:
                          TextStyle(fontSize: 16, color: Colors.grey[700]),
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
                ),
                SizedBox(
                  height: 30,
                ),
                Row(children: [
                  Expanded(
                      child: RadioListTile(
                    value: 1,
                    groupValue: selectedRadioTile,
                    title: Text("CS"),
                    onChanged: (val) {
                      print("yes");
                      setState(() {
                        group = "CS";
                      });

                      setSelectedRadioTile(val);
                    },
                    activeColor: Colors.blue,
                    selected: false,
                  )),
                  Expanded(
                      child: RadioListTile(
                    value: 2,
                    groupValue: selectedRadioTile,
                    title: Text("JS"),
                    onChanged: (val) {
                      setState(() {
                        group = "JS";
                      });

                      setSelectedRadioTile(val);
                    },
                    activeColor: Colors.blue,
                    selected: false,
                  )),
                ]),
                RaisedButton(
                    child: Text(
                      'signup',
                      style: TextStyle(fontSize: 16),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.blueGrey[900],
                    textColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20.0),
                    onPressed: () async {
                      print("signup");
                      // singUp();

                      if (_signupFormKey.currentState.validate()) {
                        Loader.showLoadingScreen(context, _keyLoader);

                        await authService.signUp(
                          _nameController.text,
                          _passwordController.text,
                          _emailController.text,
                          group,
                        );

                        Navigator.of(_keyLoader.currentContext,
                                rootNavigator: true)
                            .pop();

                        int statusCode = authService.statusCode;
                        print(statusCode);
                        if (statusCode == 200) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        }
                        if (statusCode != null && statusCode != 200) {
                          print(statusCode);

                          print(authService.msg);

                          AlertBox alertBox = AlertBox(authService.msg);
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alertBox.build(context);
                              });
                        }
                      }
                    }
                    //getCurrentUser();

                    ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
