import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  String msg;
  int statusCode;
  User currentUser;

  Future<void> signIn(String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((dynamic user) async {
      currentUser = FirebaseAuth.instance.currentUser;

      statusCode =
          200; //and at the end we will assign statuscode =200 because user login is successfull
    }).catchError((error) {
      handleAuthErrors(
          error); //or in case of any error we will handel that by using try and catch
    }); //
  }

  Future<void> signUp(
      String name, String password, String email, String group) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: email,
              password: password) //after signup we will store their
          .then((dynamic user) {
        print("signup ");

        statusCode = 200;

        User currentUser = FirebaseAuth.instance.currentUser;
        final uid = currentUser.uid;

        FirebaseFirestore.instance.collection('users').doc(uid).set({
          "StudentId": uid,
          "email": email,
          "name": name,
          "role": "user",
          "group": group
        });
      });
    } catch (error) {
      handleAuthErrors(error);
    }
  }

  void handleAuthErrors(error) {
    print("noooooooooooooooooo");
    String errorCode = error.code;
    print(errorCode);

    switch (errorCode) {
      //according to them we will assing statuscode
      case "email-already-in-use":
        {
          statusCode = 400;
          msg = "Email ID already exist";
          print("yesss");
        }
        break;
      case "too-many-requests":
        {
          statusCode = 400;
          msg = "Please try after some time you cross your max. attempt";
          print("yesss");
        }
        break;

      case "user-not-found":
        {
          statusCode = 400;
          msg = "User not found";
          print("yesss");
        }
        break;

      case "invalid-email":
        {
          statusCode = 400;
          msg = "Invalid - Email";
          print("yesss");
        }
        break;
      case "wrong-password":
        {
          print("yesss");
          statusCode = 400;
          msg = "Password is wrong";
        }
    }
  }
}
