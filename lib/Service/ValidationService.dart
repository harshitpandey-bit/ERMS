class ValidationService {
  String? validateUsername(String username) {
    if (username.isEmpty) {
      return 'Username cannot be empty';
    }
    if (username.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }
}
