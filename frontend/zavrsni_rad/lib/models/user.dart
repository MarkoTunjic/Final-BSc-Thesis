class User {
  final int? id;
  final String username;
  final String? eMail;
  final String profilePicture;
  final String? role;

  const User({
    this.id,
    this.eMail,
    required this.profilePicture,
    this.role,
    required this.username,
  });

  factory User.fromJSON(Map<String, dynamic> json) {
    print(json);
    return User(
      eMail: json["eMail"],
      id: json["id"] == null ? null : int.parse(json["id"]),
      profilePicture: json["profilePicture"],
      role: json["role"]?["roleName"],
      username: json["username"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "username": username,
        "eMail": eMail,
        "role": {"roleName": role},
        "profilePicture": profilePicture,
      };

  @override
  String toString() {
    return "User: {id: $id, username: $username, eMail: $eMail, role: $role, profilePicture: $profilePicture}";
  }
}
