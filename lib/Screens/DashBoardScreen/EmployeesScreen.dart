import 'package:erms/Screens/DashBoardScreen/Bloc/EmployeeBloc.dart';
import 'package:erms/Screens/DashBoardScreen/Bloc/EmployeeEvent.dart';
import 'package:erms/Screens/DashBoardScreen/Bloc/EmployeeState.dart';
import 'package:erms/Screens/DashBoardScreen/piechart.dart';
import 'package:erms/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeScreen extends StatefulWidget {
  final Function(int) onSectionTapped;

  const EmployeeScreen({Key? key, required this.onSectionTapped}) : super(key: key);

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch employees data when the screen is initialized
    context.read<EmployeeBloc>().add(FetchEmployees());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EmployeeLoaded) {
          final designationCounts = {
            'Developers': state.developers.length,
            'Managers': state.managers.length,
            'Business Analysts': state.businessAnalysts.length,
          };


          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Employee Types',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                PieChartSample2(
                  onSectionTapped: widget.onSectionTapped,
                  designationCounts: designationCounts,
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
    );
  }

  Widget _buildPanel(EmployeeLoaded state) {
    final items = [
      Item(headerValue: 'Developers', employees: state.developers),
      Item(headerValue: 'Managers', employees: state.managers),
      Item(headerValue: 'Business Analysts', employees: state.businessAnalysts),
    ];
    int touchIndex= state.touchedIndex;
   if(touchIndex!=-1){
    items[touchIndex].isExpanded = !items[touchIndex].isExpanded;}
    return ExpansionPanelList(
      elevation: 1,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
        });
      },
      children: items.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(onTap: (){

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


