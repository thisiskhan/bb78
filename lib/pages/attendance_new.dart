import 'package:boysbrigade/components/global/date_time.dart';
import 'package:boysbrigade/controller/logger_controller.dart';
import 'package:boysbrigade/controller/update_collection_controller.dart';
import 'package:boysbrigade/pages/home.dart';
import 'package:boysbrigade/pages/uniform.dart';
import 'package:boysbrigade/pages/uniform_new.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'half_year.dart' as halfyear;

var date = new DateTime.now();

// Our current data is assign to this variable
String currentDate =
    '${DateFormate.dateTime.day}/${DateFormate.dateTime.month}/${DateFormate.dateTime.year}';

///[AttendanceTest] is the updated version for [Attendance] class.
///
///Currently under review before it can be accepted as the main class for Attendance
class AttendanceTest extends StatefulWidget {
  final String collectionType;

  const AttendanceTest({Key key, this.collectionType}) : super(key: key);
  @override
  _AttendanceTestState createState() => _AttendanceTestState();
}

class _AttendanceTestState extends State<AttendanceTest> {
  ProgressDialog pr;
  //  This test contains all the data we will pass to firebase database
  List test = [];

  // Defining the collection we want firebase to create for us
  CollectionReference attendance;

//Data to check for snapshot
  bool data = false;
  Future checkForData() {
    // Use to check if a collection has a data
    final checkForCollection = FirebaseFirestore.instance
        .collection(
            widget.collectionType == 'CS' ? 'CsAttendance' : 'JsAttendance')
        .doc("${date.day}${date.month}${date.year}${widget.collectionType}")
        .get();

    return checkForCollection;
  }

  // This class contains all the code for firebase related
  AddToDatabase addToDatabase = AddToDatabase();

  // Global Key for our scaffold widget
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // This contains all the selected values for the current list builder
  List<String> selectedItemValue = List<String>();

  @override
  void initState() {
    checkForData().then((value) {
      if (value.exists) {
        setState(() {
          data = true;
        });
      }
    });
    //initializing Attendance
    attendance = FirebaseFirestore.instance.collection(
        widget.collectionType == 'CS' ? 'CsAttendance' : 'JsAttendance');
    // Helps in caching the data for firebase
    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
    // This when we tells the [selectedItemValue] how much item it should build
    for (int i = 0; i < halfyear.data.length; i++) {
      selectedItemValue.add("present");
    }
    // Clear everything in the test List
    test.clear();
    logger.i('AttendanceTest Initialize');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 70.0,
        elevation: 0,
        title: Text(
          "Attendance $currentDate",
          style: TextStyle(color: Colors.black),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context, MaterialPageRoute(builder: (_) => Home()));
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: halfyear.data.length,
                  itemBuilder: (context, index) {
                    print(test);
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UniformNew(
                                      name: halfyear.data[index].data()['name'],
                                      group:
                                          halfyear.data[index].data()['group'],
                                      id: halfyear.data[index]
                                          .data()['StudentId'],
                                    )));
                      },
                      child: Card(
                        child: ListTile(
                            leading:
                                Text("${halfyear.data[index].data()['group']}"),
                            title:
                                Text('${halfyear.data[index].data()['name']}'),
                            trailing: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                onChanged: (value) {
                                  test.clear();
                                  selectedItemValue[index] = value;
                                  setState(() {});
                                },
                                hint: Text('Select'),
                                value: selectedItemValue[index].toString(),
                                items: _items(),
                              ),
                            )),
                      ),
                    );
                  }),
            ),
            Container(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.blueGrey[900],
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 120),
                    onPressed: () async {
                      pr.show();
                      // We append all the data we need to send to firebase here
                      for (int i = 0; i < selectedItemValue.length; i++)
                        test.add({
                          "name": halfyear.data[i].data()['name'],
                          "status": selectedItemValue[i],
                        });

                      // Adding data to Firebase
                      await addToDatabase.addUser(
                          refrenceType: attendance,
                          context: context,
                          course: widget.collectionType,
                          data: {'data': FieldValue.arrayUnion(test)},
                          scaffoldKey: scaffoldKey).whenComplete(() => pr.hide());
                    },
                    child: Text(
                      // ignore: null_aware_in_condition
                      data ? 'Update' : 'Submit',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "OpenSans Regular",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///[_items] contains all the current attendanceType users can select
List<DropdownMenuItem<String>> _items() {
  List<String> attendanceType = ['present', 'late', 'sick', 'absent'];
  return attendanceType
      .map((value) => DropdownMenuItem(
            value: value,
            child: Text(value),
          ))
      .toList();
}
