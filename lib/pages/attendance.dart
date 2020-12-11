import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'uniform.dart';
import 'day.dart';
import 'half_year.dart' as halfyear;
import '../model/model.dart' as model;

final firestoreInstance = FirebaseFirestore.instance;
var currentDate = new DateTime.now();
StreamSubscription<DocumentSnapshot> subscription;

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  List<String> attendance = ['present', 'late', 'sick', 'absent'];
  String dropdownValue;
  Stream studentStream;

  dropDownItem(String string, int value) {
    return DropdownMenuItem(
      child: Text(string),
      value: value,
    );
  }

  @override
  void initState() {
    print("i m half  year value ${halfyear.groupvalue}");
    super.initState();
    if (halfyear.groupvalue == 'CS') {
      halfyear.newStream = FirebaseFirestore.instance
          .collection('users')
          .where('group', isEqualTo: "CS")
          .snapshots();
    } else if (halfyear.groupvalue == 'JS') {
      halfyear.newStream = FirebaseFirestore.instance
          .collection('users')
          .where('group', isEqualTo: "JS")
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'attendance',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(
                    child: Text(
                      "${currentDate.day}/${currentDate.month}/${currentDate.year}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'OpenSans SemiBold'),
                    ),
                  ),
                )
              ],
            ),
          ),
          elevation: 0,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: halfyear.newStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        return ListView(
                          shrinkWrap: true,
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            return AttendanceTile(
                              name: document.data()['name'],
                              group: document.data()['group'],
                              id: document.data()['StudentId'],
                            );
                          }).toList(),
                        );
                      }),
                ],
              ),
            ),
            // Container(
            //   color: Colors.white,
            //   child: Align(
            //     alignment: FractionalOffset.bottomCenter,
            //     child: Padding(
            //       padding: const EdgeInsets.all(10.0),
            //       child: RaisedButton(
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(30),
            //         ),
            //         color: Colors.blueGrey[900],
            //         textColor: Colors.white,
            //         padding: EdgeInsets.symmetric(vertical: 8, horizontal: 120),
            //         onPressed: () {
            //           Navigator.pop(
            //             context,
            //             MaterialPageRoute(builder: (context) => Day()),
            //           );
            //           //_AttendanceTileState().add();
            //         },
            //         child: Text(
            //           'submit',
            //           style: TextStyle(
            //             fontSize: 20,
            //             fontFamily: "OpenSans Regular",
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class AttendanceTile extends StatefulWidget {
  final String name, group, id;

  AttendanceTile({Key key, this.name, this.group, this.id}) : super(key: key);

  @override
  _AttendanceTileState createState() => _AttendanceTileState();
}

String dropdownValue;

class _AttendanceTileState extends State<AttendanceTile> {
  List<String> attendance = ['present', 'late', 'sick', 'absent'];

  var currentDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Uniform(
                        name: widget.name,
                        group: widget.group,
                        id: widget.id,
                      )));
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.group,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: "OpenSans Regular",
                ),
              ),
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: "OpenSans Regular",
                ),
              ),
              DropdownButton(
                hint: Text(
                  "select",
                  style: TextStyle(
                    fontFamily: "OpenSans SemiBold",
                  ),
                ),
                value: dropdownValue,
                onChanged: (val) {
                  setState(() {
                    dropdownValue = val;
                  });

                  if (halfyear.groupvalue == 'CS') {
                    final DocumentReference documentReference =
                        FirebaseFirestore.instance
                            .doc("csattendance/${widget.id}");
                    subscription =
                        documentReference.snapshots().listen((datasnapshot) {
                      print(documentReference);

                      FirebaseFirestore.instance
                          .collection('CSattendance')
                          .doc(
                              "${currentDate.day}${currentDate.month}${currentDate.year}")
                          .collection(widget.name)
                          .doc(widget.id)
                          .set({
                        "StudentId": widget.id,
                        "name": widget.name,
                        "group": widget.group,
                        "Status": dropdownValue
                      });
                    });
                  }
                  if (halfyear.groupvalue == 'JS') {
                    final DocumentReference documentReference =
                        FirebaseFirestore.instance
                            .doc("jsattendance/${widget.id}");
                    subscription =
                        documentReference.snapshots().listen((datasnapshot) {
                      print(documentReference);

                      FirebaseFirestore.instance
                          .collection('JSattendance')
                          .doc(
                              "${currentDate.day}${currentDate.month}${currentDate.year}")
                          .collection(widget.name)
                          .doc(widget.id)
                          .set({
                        "StudentId": widget.id,
                        "name": widget.name,
                        "group": widget.group,
                        "Status": dropdownValue
                      });
                    });
                  }
                },
                items: attendance.map((attend) {
                  return DropdownMenuItem(
                    child: Text(attend),
                    value: attend,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
