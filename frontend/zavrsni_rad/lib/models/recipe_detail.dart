import 'package:zavrsni_rad/models/ingredient.dart';
import 'package:zavrsni_rad/models/recipe_step.dart';
import 'package:zavrsni_rad/models/user.dart';

import 'comment.dart';

class RecipeDetail {
  int id;
  User user;
  double averageRating;
  int cookingDuration;
  String coverPicture;
  String recipeName;
  String description;
  int ratingFromCurrentUser;
  bool isApprooved;
  List<RecipeStep> steps;
  List<Ingredient> ingredients;
  List<String> images;
  List<String> videos;
  List<Comment> comments;

  RecipeDetail({
    required this.user,
    required this.averageRating,
    required this.cookingDuration,
    required this.coverPicture,
    required this.recipeName,
    required this.description,
    required this.images,
    required this.ingredients,
    required this.steps,
    required this.videos,
    required this.comments,
    required this.id,
    required this.ratingFromCurrentUser,
    required this.isApprooved,
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    List<dynamic> steps = json["recipeSteps"];
    List<dynamic> ingredients = json["ingredients"];
    List<dynamic> comments = json["comments"];
    List<dynamic> images = json["images"];
    List<dynamic> videos = json["videos"];
    return RecipeDetail(
        id: int.parse(json["id"]),
        recipeName: json["recipeName"],
        averageRating: json["averageRating"],
        cookingDuration: json["cookingDuration"],
        coverPicture: json["coverPicture"],
        description: json["description"],
        user: User.fromJSON(json["user"]),
        steps: steps.map((e) => RecipeStep.fromJson(e)).toList(),
        ingredients: ingredients.map((e) => Ingredient.fromJson(e)).toList(),
        images: images.map((e) => e["link"].toString()).toList(),
        videos: videos.map((e) => e["link"].toString()).toList(),
        comments: comments.map((e) => Comment.fromJson(e)).toList(),
        ratingFromCurrentUser: json["ratingFromCurrentUser"] ?? 0,
        isApprooved: json["isApprooved"]);
  }
}
