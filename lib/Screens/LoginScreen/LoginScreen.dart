import 'package:erms/Screens/LoginScreen/Bloc/LoginBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text("Login"),
         backgroundColor: Colors.teal,
         titleTextStyle: TextStyle(color: Colors.white,fontSize: 23,fontWeight: FontWeight.bold),
       ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Image.asset("asset/images/login_image1-removebg-preview.png"),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(hintText:"Username",
                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                    fillColor: Colors.grey[200]
                    ,filled: true),


              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(hintText:"Password",
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                fillColor: Colors.grey[200]
                ,filled: true),
                obscureText: true,

              ),
              SizedBox(height: 50),
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

                      SizedBox(
                        width:MediaQuery.of(context).size.width *0.6,

                        child: ElevatedButton(

                          style: ElevatedButton.styleFrom(

                          backgroundColor: Colors.teal,

                        ),

                          onPressed: () {
                            BlocProvider.of<LoginBloc>(context).add(
                              LoginButtonPressed(
                                _usernameController.text,
                                _passwordController.text,

                              ),
                            );
                          },
                          child: Text('Login',style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      SizedBox(height: 10),

                      SizedBox(
                        width:MediaQuery.of(context).size.width *0.6,
                        child: ElevatedButton(
                          style:ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[200],


                                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text('Sign Up'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
