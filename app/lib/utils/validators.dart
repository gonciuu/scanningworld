import 'package:scanning_world/utils/extensions.dart';

String? checkPassword(String? password) {
  if (!password.isValidPassword()) {
    return 'Hasło musi mieć co najmniej 6 znaków';
  }
  return null;
}

String? checkConfirmPassword(String? password, String? confirmPassword) {
  if (confirmPassword != password) {
    return 'Hasła nie są takie same';
  }
  return null;
}

String? checkFieldIsEmpty(String? value) {
  if (value == null || value.isEmpty) {
    return 'To pole nie może być puste';
  }
  return null;
}

String? checkPhoneNumber(String? phoneNumber) {
  if (phoneNumber == null || phoneNumber.isEmpty) {
    return 'To pole nie może być puste';
  }
  if (!phoneNumber.isValidPhoneNumber()) {
    return 'Nieprawidłowy numer telefonu';
  }
  return null;
}


String? checkEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'To pole nie może być puste';
  }
  if (!email.isValidEmail()) {
    return 'Nieprawidłowy adres email';
  }
  return null;
}