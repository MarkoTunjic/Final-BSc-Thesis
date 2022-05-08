import 'package:zavrsni_rad/models/user.dart';

class Comment {
  String commentText;
  User user;

  Comment({
    required this.user,
    required this.commentText,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: User.fromJSON(json["user"]),
      commentText: json["commentText"],
    );
  }
}
