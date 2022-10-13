class User {
  String name;
  String email;
  String phone;
  String? image;
  String? region;

  User({
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    this.region,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        image: json["image"],
        region: json["region"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "image": image,
        "region": region,
  };
}
