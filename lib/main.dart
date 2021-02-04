import 'package:boysbrigade/model/attendance_model.dart';
import 'package:boysbrigade/pages/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:boysbrigade/pages/error.dart';
import 'package:boysbrigade/pages/login.dart';

import 'model/api_locator.dart';
import 'model/attendance_data.dart';
import 'pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setup();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  String testProviderText = "Hello provider";
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Error(),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          FirebaseAuth auth = FirebaseAuth.instance;
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (_) => getIt<AttendanceData>()),
                  Provider<String>(create: (context) => testProviderText),
                  StreamProvider<User>(
                      create: (context) =>
                          FirebaseAuth.instance.authStateChanges())
                ],
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: auth.currentUser != null ? Home() : Login(),
                ),
              ));
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Loading(),
        );
      },
    );
  }
}
