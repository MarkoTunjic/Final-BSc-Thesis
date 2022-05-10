import 'package:zavrsni_rad/models/user.dart';

class Comment {
  String commentText;
  User user;
  int id;

  Comment({
    required this.user,
    required this.commentText,
    required this.id,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: int.parse(json["id"]),
      user: User.fromJSON(json["user"]),
      commentText: json["commentText"],
    );
  }
}
