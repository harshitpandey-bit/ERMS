import 'package:erms/Screens/DashBoardScreen/Bloc/EmployeeBloc.dart';
import 'package:erms/Screens/DashBoardScreen/Bloc/EmployeeEvent.dart';
import 'package:erms/Screens/DashBoardScreen/Bloc/EmployeeState.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PieChartSample2 extends StatelessWidget {
  final Function(int) onSectionTapped;
  final Map<String, int> designationCounts;

  const PieChartSample2({
    Key? key,
    required this.onSectionTapped,
    required this.designationCounts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: BlocBuilder<EmployeeBloc, EmployeeState>(
                builder: (context, state) {
                  final touchedIndex = state is EmployeeLoaded ? state.touchedIndex : -1;

                  return PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          if (!event.isInterestedForInteractions || pieTouchResponse == null) {
                            return;
                          }

                          if (pieTouchResponse.touchedSection != null) {
                            final index = pieTouchResponse.touchedSection!.touchedSectionIndex;
                            context.read<EmployeeBloc>().add(PieChartTouchEvent(index));
                            onSectionTapped(index);
                          }
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 70,
                      sections: showingSections(touchedIndex),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(int touchedIndex) {
    final sections = <PieChartSectionData>[];
    final colors = [Colors.blue, Colors.yellow, Colors.purple];
    final titles = ['Developers', 'Managers', 'Business Analysts'];

    int i = 0;
    for (var entry in designationCounts.entries) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      sections.add(
        PieChartSectionData(
          color: colors[i % colors.length], // To avoid index out of bounds
          value: entry.value.toDouble(),
          title: '${entry.value}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: isTouched ? Colors.white : Colors.black,
          ),
        ),
      );
      i++;
    }

    return sections;
  }
}
