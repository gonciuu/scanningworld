
class Session{
  String refreshToken;
  String accessToken;

  Session({
    required this.refreshToken,
    required this.accessToken,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    refreshToken: json["refreshToken"],
    accessToken: json["accessToken"],
  );
  Map<String, dynamic> toJson() => {
    "refreshToken": refreshToken,
    "accessToken": accessToken,
  };
}