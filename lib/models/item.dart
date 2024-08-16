class Item {
  Item({
    required this.headerValue,
    this.employees = const [],
    this.isExpanded = false,
  });

  String headerValue;
  List<Map<String, dynamic>> employees;
  bool isExpanded;
}
