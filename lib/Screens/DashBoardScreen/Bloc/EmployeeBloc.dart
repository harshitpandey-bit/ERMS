import 'package:erms/Service/DBHelper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erms/Screens/DashBoardScreen/Bloc/EmployeeEvent.dart';
import 'package:erms/Screens/DashBoardScreen/Bloc/EmployeeState.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final DatabaseHelper databaseHelper;

  EmployeeBloc({required this.databaseHelper}) : super(EmployeeLoading()) {
    on<FetchEmployees>(_onFetchEmployees);
    on<PieChartTouchEvent>(_onPieChartTouchEvent);
    on<UpdateEmployeeAttendance>(_onUpdateEmployeeAttendance);
  }
  void _onFetchEmployees(FetchEmployees event, Emitter<EmployeeState> emit) async {
   print("fetching date from database............");
    try {
      final developers = await databaseHelper.getEmployeesByDesignation('Developer');
      final managers = await databaseHelper.getEmployeesByDesignation('Manager');
      final businessAnalysts = await databaseHelper.getEmployeesByDesignation('Business Analyst');

      emit(EmployeeLoaded(
        developers: developers,
        managers: managers,
        businessAnalysts: businessAnalysts,
      ));
      print("emiting data from Bloc...........");
    } catch (e) {
      emit(EmployeeError('Failed to fetch employees.'));
    }
  }


  void _onPieChartTouchEvent(PieChartTouchEvent event, Emitter<EmployeeState> emit) {
    if (state is EmployeeLoaded) {

      final currentState = state as EmployeeLoaded;
      emit(EmployeeLoaded(
        developers: currentState.developers,
        managers: currentState.managers,
        businessAnalysts: currentState.businessAnalysts,
        touchedIndex: event.touchedIndex,
      ));
    }
  }
  void _onExpandPanelEvent(ExpandPanelEvent event, Emitter<EmployeeState> emit) {
    if (state is EmployeeLoaded) {
      final currentState = state as EmployeeLoaded;
      emit(EmployeeLoaded(
        developers: currentState.developers,
        managers: currentState.managers,
        businessAnalysts: currentState.businessAnalysts,
        touchedIndex: currentState.touchedIndex,
        expandedPanelIndex: event.panelIndex,
      ));
    }
  }

  void _onUpdateEmployeeAttendance(UpdateEmployeeAttendance event, Emitter<EmployeeState> emit) async {
    if (state is EmployeeLoaded) {
      final currentState = state as EmployeeLoaded;

      try {
        // Update the attendance in the database
        await databaseHelper.updateAttendance(event.employeeId, event.newStatus);


        // Fetch the updated employee data
        final developers = await databaseHelper.getEmployeesByDesignation('Developer');
        final managers = await databaseHelper.getEmployeesByDesignation('Manager');
        final businessAnalysts = await databaseHelper.getEmployeesByDesignation('Business Analyst');
       print(developers);
        emit(EmployeeLoaded(
          developers: developers,
          managers: managers,
          businessAnalysts: businessAnalysts,
          touchedIndex: currentState.touchedIndex,
        ));
      } catch (e) {
        emit(EmployeeError('Failed to update employee attendance.'));
      }
    }
  }

}


