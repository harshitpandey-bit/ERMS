import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatelessWidget {
  Future<void> _logout(BuildContext context) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn',false);
    Navigator.of(context).pushReplacementNamed("/login");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'),
      actions: [ElevatedButton(onPressed:()=> _logout(context), child: Text("Logout"))],),
      body: Center(
        child: Text('Welcome to the Dashboard!'),
      ),
    );
  }
}
