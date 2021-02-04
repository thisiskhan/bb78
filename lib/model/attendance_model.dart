
import 'package:json_annotation/json_annotation.dart';

part 'attendance_model.g.dart';

///[Attendace Model] this config he Model for the data read from the firebase
@JsonSerializable()
class AttendaceModel {
  String data;
  AttendaceModel();

  factory AttendaceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendaceModelFromJson(json);
  Map<String, dynamic> toJson() => _$AttendaceModelToJson(this);
}
