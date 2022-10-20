class Region {
  final String id;
  final String name;
  final String? email;
  final int? placeCount;

  Region({
    required this.id,
    required this.name,
    this.email,
    this.placeCount,
  });

  //from json
  factory Region.fromJson(Map<String, dynamic> json) => Region(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        placeCount: json["placeCount"],
      );

  //to json
  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "placeCount": placeCount,
      };
}
