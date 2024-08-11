import 'package:bloc/bloc.dart';
import 'package:erms/Service/DBHelper.dart';
import 'package:erms/Service/ValidationService.dart';


abstract class SignupEvent {}

class SignupButtonPressed extends SignupEvent {
  final String username;
  final String password;
  final String email;

  SignupButtonPressed(this.username, this.password, this.email);
}

abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailure extends SignupState {
  final String error;

  SignupFailure(this.error);
}

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ValidationService _validationService = ValidationService();

  SignupBloc() : super(SignupInitial()) {
    on<SignupButtonPressed>((event, emit) async {
      final usernameError = _validationService.validateUsername(event.username);
      final passwordError = _validationService.validatePassword(event.password);
      final emailError = _validationService.validateEmail(event.email);

      if (usernameError != null) {
        emit(SignupFailure(usernameError));
        return;
      }

      if (passwordError != null) {
        emit(SignupFailure(passwordError));
        return;
      }

      if (emailError != null) {
        emit(SignupFailure(emailError));
        return;
      }

      emit(SignupLoading());
      try {
        // Check if the user already exists
        final existingUser = await _dbHelper.getUserByUsername(event.username);
        if (existingUser != null) {
          emit(SignupFailure('Username already exists'));
          return;
        }

        // Insert the new user
        await _dbHelper.insertUser({
          'username': event.username,
          'password': event.password,
          'email': event.email,
        });

        emit(SignupSuccess());
      } catch (e) {
        emit(SignupFailure(e.toString()));
      }
    });
  }
}
