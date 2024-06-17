String? nullValidator(String? value) {
  return null;
}

String? emailValidator(String? email) {
  if (email == null || email.isEmpty) {
    return 'Enter email';
  } else if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email)) {
    return 'Email is invalid';
  } else {
    return null;
  }
}

String? passwordValidator(String? password) {
  if (password == null || password.isEmpty) {
    return 'Enter password';
  } else if (password == "loi") {
    return 'Password is invalid';
  } else {
    return null;
  }
}