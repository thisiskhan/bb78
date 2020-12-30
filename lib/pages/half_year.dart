import 'package:boysbrigade/model/cubit/attendance_cubit.dart';
import 'package:boysbrigade/pages/group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String groupvalue = "CS";
Stream<QuerySnapshot> newStream;
List data = ['sick'];

class HalfYear extends StatelessWidget {
  final String id;

  const HalfYear({Key key, this.id}) : super(key: key);

  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    var _width = (_screenWidth - 20) / 2;
    var _aspectRatio = _width / 250;

    return BlocProvider(
      create: (create) => AttendanceCubit(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            centerTitle: true,
            actions: <Widget>[
              BlocBuilder<AttendanceCubit, String>(
                builder: (context, state) {
                  var current = context.watch<AttendanceCubit>();
                  groupvalue = state;
                  return Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: DropdownButton<String>(
                      value: state,
                      onChanged: current.onChanged,
                      items: <String>['CS', 'JS']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
            automaticallyImplyLeading: false,
            title: Text(
              '上半年', //half year
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 20,
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey[50],
        body: BlocBuilder<AttendanceCubit, String>(
          builder: (context, state) => StreamBuilder(
            stream: state == 'JS'
                ? FirebaseFirestore.instance
                    .collection('students')
                    .where('group', isEqualTo: "JS")
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('students')
                    .where('group', isEqualTo: "CS")
                    .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              data.clear();
              List<DocumentSnapshot> groupUsers;
              if (snapshot.hasData) {
                groupUsers = snapshot.data.documents;
                data.addAll(groupUsers);
                return GridView.builder(
                  padding: const EdgeInsets.all(30),
                  itemCount: snapshot.data.documents.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 30,
                      crossAxisCount: 2,
                      childAspectRatio: _aspectRatio),
                  itemBuilder: (context, int index) {
                    // data.add(groupUsers[index].data()['name']);
                    print(data);

                    return InkWell(
                      child: Container(
                        height: 290.0,
                        padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              groupUsers[index].data()['group'],
                              style: TextStyle(
                                color: Colors.blueGrey[900],
                                fontSize: 35,
                                fontFamily: "OpenSans Regular",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '人數:',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  groupUsers.length.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 3,
                              offset:
                                  Offset(8, 5), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Group(
                                      group: groupUsers[index].data()['group'],
                                      name: groupUsers[index].data()['name'],
                                      status:
                                          groupUsers[index].data()['status'],
                                      total:
                                          groupUsers[index].data()['totalMark'],
                                      id: this.id,
                                    )));
                      },
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
