import 'package:zavrsni_rad/models/user.dart';

class RecipeMaster {
  User user;
  double averageRating;
  int cookingDuration;
  String coverPicture;
  String recipeName;
  bool isLikedByCurrentUser;

  RecipeMaster({
    required this.user,
    required this.averageRating,
    required this.cookingDuration,
    required this.coverPicture,
    required this.recipeName,
    required this.isLikedByCurrentUser,
  });

  factory RecipeMaster.fromJson(Map<String, dynamic> json) {
    print(json["user"]);
    return RecipeMaster(
        user: User.fromJSON(json["user"]),
        averageRating: json["averageRating"],
        cookingDuration: json["cookingDuration"],
        coverPicture: json["coverPicture"],
        recipeName: json["recipeName"],
        isLikedByCurrentUser: json["isLikedByCurrentUser"]);
  }
}
