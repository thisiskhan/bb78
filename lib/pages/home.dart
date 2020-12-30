import 'package:boysbrigade/controller/logger_controller.dart';
import 'package:boysbrigade/pages/attendance.dart';
import 'package:boysbrigade/pages/attendance_test.dart';
import 'package:boysbrigade/pages/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './half_year.dart';
import './day.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedTab = 0;

  final List<Widget> _tabs = [
    HalfYear(),
    Day(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    logger.i('Home Initialize');
    final user = Provider.of<User>(context);
    final bool isAuthenticated = user != null;

    return Scaffold(
      body:
          Center(child: isAuthenticated ? _tabs.elementAt(_selectedTab) : null),
      // body: _tabs.elementAt(_selectedTab),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueGrey[900],
        unselectedItemColor: Colors.grey[400],
        iconSize: 45,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: 'half year',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'day',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings',
          ),
        ],
      ),
      floatingActionButton: _selectedTab == 0
          ? Container(
              height: 75.0,
              width: 75.0,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AttendanceTest()));
                },
                child: Icon(
                  Icons.add,
                  size: 35,
                ),
                backgroundColor: Colors.blueGrey[900],
                elevation: 5,
              ),
            )
          : null,
    );
  }
}
