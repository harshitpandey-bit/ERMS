import 'package:erms/Screens/DashBoardScreen/DashBoardScreen.dart';
import 'package:erms/Screens/LoginScreen/Bloc/LoginBloc.dart';
import 'package:erms/Screens/LoginScreen/LoginScreen.dart';
import 'package:erms/Screens/SignupScreen/Bloc/SignupBloc.dart';
import 'package:erms/Screens/SignupScreen/SignupScreen.dart';
import 'package:erms/Screens/SplashScreen/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(MyApp());
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
