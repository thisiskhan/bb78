import 'package:boysbrigade/model/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import 'api_locator.dart';
import 'attendance_model.dart';

///Attendance data to change for any update from firebase
class AttendanceData extends ChangeNotifier {
  Api _api = getIt<Api>();

  List<AttendaceModel> attendance;

  Future<List<AttendaceModel>> getData() async {
    var result = await _api.getDataCollection();

    attendance =
        result.docs.map((e) => AttendaceModel.fromJson(e.data())).toList();

    return attendance;
  }

  Stream<QuerySnapshot> fetchProductsAsStream(data) {
    return _api.streamDataCollection(data);
  }
}
