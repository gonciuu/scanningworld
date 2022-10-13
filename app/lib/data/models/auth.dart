class RegisterData {
  String email = '';
  String phoneNumber = '';
  String password = '';
  String confirmPassword = '';
  String username = '';
  String city = '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = email;
    data['phone'] = phoneNumber;
    data['password'] = password;
    data['password_confirmation'] = confirmPassword;
    data['name'] = username;
    data['city'] = city;
    return data;
  }
}
