abstract class EmployeeState {}
class EmployeeLoading extends EmployeeState {}
class EmployeeLoaded extends EmployeeState {
  final List<Map<String, dynamic>> developers;
  final List<Map<String, dynamic>> managers;
  final List<Map<String, dynamic>> businessAnalysts;
  final int touchedIndex;
  final int? expandedPanelIndex;

  EmployeeLoaded({
    required this.developers,
    required this.managers,
    required this.businessAnalysts,
    this.touchedIndex = -1,
    this.expandedPanelIndex,
  });
}

class EmployeeError extends EmployeeState {
  final String message;

  EmployeeError(this.message);
}
