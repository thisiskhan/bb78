import 'package:bloc/bloc.dart';

/// [AttendanceCubit] changes our screen state based on the seleted course [JS][CS]
class AttendanceCubit extends Cubit<String> {
  AttendanceCubit() : super('JS');

// Chnaging our class base on the current state
  void onChanged(value) {
    emit(value);
  }
}
