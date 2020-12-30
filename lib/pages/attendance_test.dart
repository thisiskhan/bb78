import 'package:boysbrigade/components/global/date_time.dart';
import 'package:boysbrigade/controller/logger_controller.dart';
import 'package:boysbrigade/controller/update_collection_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'half_year.dart' as halfyear;

// Our current data is assign to this variable
String currentDate = '${DateFormate.dateTime.day}' +
    '${DateFormate.dateTime.month}' +
    '${DateFormate.dateTime.year}';

///[AttendanceTest] is the updated version for [Attendance] class.
///
///Currently under review before it can be accepted as the main class for Attendance
class AttendanceTest extends StatefulWidget {
  @override
  _AttendanceTestState createState() => _AttendanceTestState();
}

class _AttendanceTestState extends State<AttendanceTest> {
  //  This test contains all the data we will pass to firebase database
  List test = [];

  // Defining the collection we want firebase to create for us
  CollectionReference attendance =
      FirebaseFirestore.instance.collection('CsAttendance');

  // This class contains all the code for firebase related
  AddToDatabase addToDatabase = AddToDatabase();

  // Global Key for our scaffold widget
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // This contains all the selected values for the current list builder
  List<String> selectedItemValue = List<String>();

  @override
  void initState() {
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
        leading: Icon(
          Icons.arrow_back,
          color: Colors.black,
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
                    return Card(
                      child: ListTile(
                          leading:
                              Text("${halfyear.data[index].data()['group']}"),
                          title: Text('${halfyear.data[index].data()['name']}'),
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
                          course: 'CS',
                          data: {'data': FieldValue.arrayUnion(test)},
                          scaffoldKey: scaffoldKey);
                    },
                    child: Text(
                      'Submit',
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
