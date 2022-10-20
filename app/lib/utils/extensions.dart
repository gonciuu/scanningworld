import 'dart:math';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension PasswordValidator on String? {
  bool isValidPassword() {
    if (this == null || this!.isEmpty) {
      return false;
    }
    return this!.length >= 6;
  }
}

extension PhoneNumberValidator on String? {
  bool isValidPhoneNumber() {
    if (this == null || this!.isEmpty) {
      return false;
    }
    return this!.length >= 9;
  }
}

extension RandomListItem<T> on List<T> {
  T? randomItem() {
    if(isEmpty) {
      return null;
    }else{
      return this[Random().nextInt(this.length)];
    }

  }
}