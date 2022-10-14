class Region {
  final String id;
  final String name;

  Region({
    required this.id,
    required this.name,
  });

  //from json
  factory Region.fromJson(Map<String, dynamic> json) => Region(
        id: json["_id"],
        name: json["name"],
      );

  //to json
  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
