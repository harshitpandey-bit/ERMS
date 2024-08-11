import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:erms/Service/DBHelper.dart';
import 'package:erms/Service/ValidationService.dart';

abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  LoginButtonPressed(this.username, this.password);
}

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ValidationService _validationService = ValidationService();

  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      final usernameError = _validationService.validateUsername(event.username);
      final passwordError = _validationService.validatePassword(event.password);

      if (usernameError != null) {
        emit(LoginFailure(usernameError));
        return;
      }

      if (passwordError != null) {
        emit(LoginFailure(passwordError));
        return;
      }

      emit(LoginLoading());
      try {
        final user = await _dbHelper.getUserByUsername(event.username);
        if (user == null || user['password'] != event.password) {
          emit(LoginFailure('Invalid username or password'));
          return;
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }
}
