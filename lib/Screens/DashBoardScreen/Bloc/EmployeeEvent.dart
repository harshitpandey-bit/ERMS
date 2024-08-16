abstract class EmployeeEvent {}

class FetchEmployees extends EmployeeEvent {}

class PieChartTouchEvent extends EmployeeEvent {
  final int touchedIndex;

  PieChartTouchEvent(this.touchedIndex);
}

class UpdateEmployeeAttendance extends EmployeeEvent {
  final int employeeId;
  final String newStatus;

  UpdateEmployeeAttendance({required this.employeeId, required this.newStatus});
}
class ExpandPanelEvent extends EmployeeEvent {
  final int panelIndex;

  ExpandPanelEvent(this.panelIndex);
}
