import 'package:erms/Screens/SignupScreen/Bloc/SignupBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SignupScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
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
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            BlocConsumer<SignupBloc, SignupState>(
              listener: (context, state) {
                if (state is SignupFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                } else if (state is SignupSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Signup Successful')),
                  );
                }
              },
              builder: (context, state) {
                if (state is SignupLoading) {
                  return CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<SignupBloc>(context).add(
                      SignupButtonPressed(
                        _usernameController.text,
                        _passwordController.text,
                        _emailController.text,
                      ),
                    );
                  },
                  child: Text('Signup'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
