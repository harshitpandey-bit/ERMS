

import 'package:erms/Screens/DashBoardScreen/AttendenceScreen.dart';
import 'package:erms/Screens/DashBoardScreen/EmployeesScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> _children(BuildContext context) => [
    EmployeeScreen(onSectionTapped: (index){},

    ),
    AttendenceScreen(
      onSectionTapped: (index) {
        // Handle any actions when a section is tapped in the Present Employees Pie Chart
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          ElevatedButton(
            onPressed: () => _logout(context),
            child: const Text('Logout'),
          ),
        ],
      ),
      body: _children(context)[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Employees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Attendence',
          ),
        ],
      ),
    );
  }
}

