import 'package:boysbrigade/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

var currentDate = new DateTime.now();

/// [UpdateFirebaseCollection] update csAttendance when ever the method is been called
class UpdateCsAttendanceCollection {
  //=========================== Local Variable ===================================//
  CollectionReference csAttendance =
      FirebaseFirestore.instance.collection('CSattendance');

  //=========================== Method ===================================//
  Future<void> updateAttendance({String document, String content}) {
    return csAttendance
        .doc(document)
        .update({'company': content})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}

class AddToDatabase {
  Future<void> addUser({refrenceType, data, scaffoldKey, context, course}) {
    return refrenceType
        .doc("${currentDate.day}${currentDate.month}${currentDate.year}$course")
        .set(data)
        .then((value) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text("Added sucessfully"),
      ));
      Future.delayed(Duration(seconds: 2), () => Navigator.pop(context));
    }).catchError((error) => print("Failed to add user: $error"));
  }
}
