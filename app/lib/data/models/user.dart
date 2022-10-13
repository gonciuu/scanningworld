class User {
  String name;
  String email;
  String phone;
  String? image;
  String? token;
  String? city;

  User({
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    required this.token,
    this.city,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        image: json["image"],
        token: json["token"],
        city: json["city"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['city'] = city;
    data['image'] = image;
    data['token'] = token;
    return data;
  }
}
