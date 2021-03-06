import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:boysbrigade/controller/update_collection_controller.dart';
import 'package:progress_dialog/progress_dialog.dart';

var currentDate = new DateTime.now();

///[UniformNew] this class is a new class for [uniform] screen.
///
///it is under review before it will be converted to uniform screen
class UniformNew extends StatefulWidget {
  final String name, group, id;

  const UniformNew({Key key, this.name, this.group, this.id}) : super(key: key);
  @override
  _UniformNewState createState() => _UniformNewState();
}

class _UniformNewState extends State<UniformNew> {
  ProgressDialog pr;
  //Emapty list to hold all our Firebase data
  List test = [];
  // This contains all the selected values for the current list builder
  List<String> selectedItemValue = List<String>();

  // Asign all the need content to a varriable [itemName]
  List<String> itemName = ['shirt', 'pant', 'shoe', 'other'];

  // This class contains all the code for firebase related
  AddToDatabase addToDatabase = AddToDatabase();

  // Defining the collection we want firebase to create for us
  CollectionReference attendance;

  // Global Key for our scaffold widget
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // This when we tells the [selectedItemValue] how much item it should build
    for (int i = 0; i < itemName.length; i++) {
      selectedItemValue.add('1');
    }
    //initializing Attendance
    attendance = FirebaseFirestore.instance
        .collection(widget.group == 'CS' ? 'CsMarks' : 'JsMarks');

    // Clear everything in the test List
    test.clear();
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.blueGrey[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'uniform',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "${currentDate.day}/${currentDate.month}/${currentDate.year}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'OpenSans SemiBold'),
                ),
              ),
            ],
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 20.0,
          ),
          Text(
            widget.name,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: "OpenSans Regular",
            ),
          ),
          Text(
            widget.group,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "OpenSans Regular",
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Uniform',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: "OpenSans SemiBold",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Mark',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: "OpenSans SemiBold",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itemName.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListTile(
                      leading: Text(
                        '${itemName[index]}',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "OpenSans SemiBold",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          onChanged: (value) {
                            test.clear();
                            selectedItemValue[index] = value;
                            setState(() {});
                          },
                          value: selectedItemValue[index].toString(),
                          items: _markValue(),
                        ),
                      )),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: FractionalOffset.bottomCenter,
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
                        "name": itemName[i],
                        "mark": selectedItemValue[i],
                      });

                    // Adding data to Firebase
                    await addToDatabase
                        .addUser(
                            refrenceType: attendance,
                            context: context,
                            course: widget.name,
                            data: {'data': FieldValue.arrayUnion(test)},
                            scaffoldKey: scaffoldKey)
                        .whenComplete(() {
                      pr.hide();
                    });
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///[_items] contains all the current attendanceType users can select
List<DropdownMenuItem<String>> _markValue() {
  List<String> attendanceType = ['1', '2', '3'];
  return attendanceType
      .map((value) => DropdownMenuItem(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontFamily: "OpenSans SemiBold",
                fontWeight: FontWeight.bold,
              ),
            ),
          ))
      .toList();
}
