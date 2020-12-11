import 'package:boysbrigade/provider/auth_prodiver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

final _firestore = FirebaseFirestore.instance;

class Forgotpassword extends StatefulWidget {
  @override
  _ForgotpasswordState createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final _ForgotpasswordFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  AuthService authService = new AuthService();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Future<void> resetpassword() async {
    await auth.sendPasswordResetEmail(email: _emailController.text);

    setState(() {
      _emailController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 50, 40, 0),
          child: Form(
            key: _ForgotpasswordFormKey,
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
                      hintText: 'email',
                      hintStyle:
                          TextStyle(fontSize: 16, color: Colors.grey[700]),
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
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: RaisedButton(
                    child: Text(
                      'Submit',
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
                      resetpassword();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
