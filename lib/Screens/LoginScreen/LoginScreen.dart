import 'package:erms/Screens/LoginScreen/Bloc/LoginBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                } else if (state is LoginSuccess) {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                }
              },
              builder: (context, state) {
                if (state is LoginLoading) {
                  return CircularProgressIndicator();
                }
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<LoginBloc>(context).add(
                          LoginButtonPressed(
                            _usernameController.text,
                            _passwordController.text,
                          ),
                        );
                      },
                      child: Text('Login'),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text('Sign Up'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
