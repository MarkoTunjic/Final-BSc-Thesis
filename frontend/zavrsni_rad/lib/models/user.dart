class User {
  int? id;
  String username;
  String? eMail;
  String profilePicture;
  String? role;
  bool? isBanned;

  User({
    this.isBanned,
    this.id,
    this.eMail,
    required this.profilePicture,
    this.role,
    required this.username,
  });

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(
      eMail: json["eMail"],
      id: json["id"] == null ? null : int.parse(json["id"]),
      profilePicture: json["profilePicture"],
      role: json["role"]?["roleName"],
      username: json["username"],
      isBanned: json["isBanned"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "username": username,
        "eMail": eMail,
        "role": {"roleName": role},
        "profilePicture": profilePicture,
        "isBanned": isBanned,
      };

  @override
  String toString() {
    return "User: {id: $id, username: $username, eMail: $eMail, role: $role, profilePicture: $profilePicture, isBanned: $isBanned}";
  }
}
