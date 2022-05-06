import 'dart:convert';

import 'package:zavrsni_rad/models/ingredient.dart';

class NewRecipe {
  String? coverPicture;
  String? recipeName;
  String? description;
  double? cookingDuration;
  List<String>? images;
  List<String>? videos;
  List<Ingredient>? ingredients;

  NewRecipe({
    this.cookingDuration,
    this.coverPicture,
    this.recipeName,
    this.description,
    this.images,
    this.videos,
    this.ingredients,
  });

  Map<String, dynamic> toJson() {
    return {
      "coverPicture": coverPicture,
      "recipeName": recipeName,
      "description": description,
      "cookingDuration": cookingDuration.toString(),
      "images": jsonEncode(images),
      "videos": jsonEncode(videos),
      "ingredients": jsonEncode(ingredients),
    };
  }
}
