import 'package:erms/Screens/DashBoardScreen/Bloc/EmployeeBloc.dart';
import 'package:erms/Screens/DashBoardScreen/Bloc/EmployeeEvent.dart';
import 'package:erms/Screens/DashBoardScreen/Bloc/EmployeeState.dart';
import 'package:erms/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

class AttendenceScreen extends StatefulWidget {
  const AttendenceScreen({super.key, required this.onSectionTapped});

  final Function(int) onSectionTapped;

  @override
  State<AttendenceScreen> createState() => AttendenceScreenState();
}

class AttendenceScreenState extends State<AttendenceScreen> {
  List<Item> items = []; // Initialize items with an empty list
  int expandedIndex=-1; // Track the index of the expanded panel

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeBloc, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeLoaded) {
          setState(() {


            print('Employees loaded successfully.');
          });
        } else if (state is EmployeeError) {
          print('Error loading employees: ${state.message}');
        }
      },
      child: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoaded) {
            items = [
              Item(headerValue: 'Present', employees: state.developers.where((e) => e['attendance'] == 'Present').toList() +
                  state.managers.where((e) => e['attendance'] == 'Present').toList() +
                  state.businessAnalysts.where((e) => e['attendance'] == 'Present').toList()),
              Item(headerValue: 'Absent', employees: state.developers.where((e) => e['attendance'] == 'Absent').toList() +
                  state.managers.where((e) => e['attendance'] == 'Absent').toList() +
                  state.businessAnalysts.where((e) => e['attendance'] == 'Absent').toList()),
              Item(headerValue: 'Leave', employees: state.developers.where((e) => e['attendance'] == 'Leave').toList() +
                  state.managers.where((e) => e['attendance'] == 'Leave').toList() +
                  state.businessAnalysts.where((e) => e['attendance'] == 'Leave').toList()),
            ];
            final designationCounts = {
              'Present': state.developers.where((e) => e['attendance'] == 'Present').length +
                  state.managers.where((e) => e['attendance'] == 'Present').length +
                  state.businessAnalysts.where((e) => e['attendance'] == 'Present').length,
              'Absent': state.developers.where((e) => e['attendance'] == 'Absent').length +
                  state.managers.where((e) => e['attendance'] == 'Absent').length +
                  state.businessAnalysts.where((e) => e['attendance'] == 'Absent').length,
              'Leave': state.developers.where((e) => e['attendance'] == 'Leave').length +
                  state.managers.where((e) => e['attendance'] == 'Leave').length +
                  state.businessAnalysts.where((e) => e['attendance'] == 'Leave').length,
            };

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Attendance Status',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 250, // Constrain the height of the PieChart
                    child: PieChart(
                      PieChartData(centerSpaceRadius: 70,
                        sections: showingSections(designationCounts),
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            if (!event.isInterestedForInteractions || pieTouchResponse == null) {
                              return;
                            }

                            if (pieTouchResponse.touchedSection != null) {
                              final index = pieTouchResponse.touchedSection!.touchedSectionIndex;
                              widget.onSectionTapped(index);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildPanel(state),
                ],
              ),
            );
          } else if (state is EmployeeError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unexpected state'));
          }
        },
      ),
    );
  }

  List<PieChartSectionData> showingSections(Map<String, int> designationCounts) {
    final sections = <PieChartSectionData>[];
    final colors = [Colors.green, Colors.red, Colors.orange];
    final titles = ['Present', 'Absent', 'Leave'];

    for (int i = 0; i < titles.length; i++) {
      final isTouched = false; // You can customize this if you want to handle touches
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      sections.add(
        PieChartSectionData(
          color: colors[i],
          value: designationCounts[titles[i]]?.toDouble(),
          title: '${designationCounts[titles[i]]}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: isTouched ? Colors.white : Colors.black,
          ),
        ),
      );
    }

    return sections;
  }

  Widget _buildPanel(EmployeeLoaded state) {
    if(expandedIndex!=-1){
      items[expandedIndex].isExpanded= !items[expandedIndex].isExpanded;
    }
    return ExpansionPanelList(
      elevation: 1,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          if (expandedIndex == index) {
            expandedIndex = -1; // Collapse the panel if it is already expanded
          } else {
            expandedIndex = index; // Expand the new panel
          }
        });
      },
      children: items.map<ExpansionPanel>((Item item) {

        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              onTap: () {
                setState(() {
                expandedIndex= items.indexOf(item);
                });
              },
              title: Text(item.headerValue, style: const TextStyle(fontWeight: FontWeight.bold)),
            );
          },
          body: Column(
            children: item.employees.map((employee) {
              return ListTile(
                title: Text(employee['username']),
                subtitle: Text(employee['designation']),
                trailing: DropdownButton<String>(
                  value: employee['attendance'], // Current attendance status
                  onChanged: (newValue) {
                    if (newValue != null) {
                      context.read<EmployeeBloc>().add(UpdateEmployeeAttendance(
                        employeeId: employee['id'],
                        newStatus: newValue,
                      ));
                    }
                  },
                  items: ['Present', 'Absent', 'Leave'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
