class RegisterData {
  String email = '';
  String phone = '';
  String password = '';
  String confirmPassword = '';
  String name = '';
  String regionId = '';
  String pinCode='';


  Map<String, dynamic> toJson() =>
      {
        'email': email,
        'phone': phone,
        'password': password,
        'confirmPassword': confirmPassword,
        'name': name,
        'regionId': regionId,
      };

}
