import 'package:erms/Screens/DashBoardScreen/Bloc/EmployeeBloc.dart';
import 'package:erms/Screens/DashBoardScreen/DashBoardScreen.dart';
import 'package:erms/Screens/LoginScreen/Bloc/LoginBloc.dart';
import 'package:erms/Screens/LoginScreen/LoginScreen.dart';
import 'package:erms/Screens/SignupScreen/Bloc/SignupBloc.dart';
import 'package:erms/Screens/SignupScreen/SignupScreen.dart';
import 'package:erms/Screens/SplashScreen/SplashScreen.dart';
import 'package:erms/Service/DBHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

Future<void> deleteDb() async {
  // Get the path to the database
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'app_database.db');

  // Delete the database
  await deleteDatabase(path);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<SignupBloc>(
          create: (context) => SignupBloc(),
        ),
        BlocProvider<EmployeeBloc>(
          create: (context) => EmployeeBloc(databaseHelper: DatabaseHelper()),
        ),
      ],
      child: MaterialApp(
        title: 'Login App',
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/dashboard': (context) => DashboardScreen(),
        },
      ),
    );
  }
}
