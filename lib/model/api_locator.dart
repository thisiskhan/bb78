import 'package:get_it/get_it.dart';


import 'attendance_data.dart';

final getIt = GetIt.instance;

///Locator to inject our api
void setup() {
  getIt.registerLazySingleton(() => AttendanceData());
}
