class RegisterData {
  String email = '';
  String phone = '';
  String password = '';
  String confirmPassword = '';
  String name = '';
  String region = '';
  String pinCode='';


  Map<String, dynamic> toJson() =>
      {
        'email': email,
        'phone': phone,
        'password': password,
        'confirmPassword': confirmPassword,
        'name': name,
        'region': region,
      };

}
