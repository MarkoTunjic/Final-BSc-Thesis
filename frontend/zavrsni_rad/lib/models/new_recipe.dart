import 'package:zavrsni_rad/models/ingredient.dart';
import 'package:zavrsni_rad/models/recipe_step.dart';

class NewRecipe {
  int? userId;
  String? coverPicture;
  String? recipeName;
  String? description;
  int? cookingDuration;
  List<String>? images;
  List<RecipeStep>? steps;
  List<String>? videos;
  List<String>? videoExtensions;
  List<Ingredient>? ingredients;

  NewRecipe({
    this.userId,
    this.cookingDuration,
    this.coverPicture,
    this.recipeName,
    this.description,
    this.images,
    this.videos,
    this.ingredients,
    this.videoExtensions,
    this.steps,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "coverPicture": coverPicture,
      "recipeName": recipeName,
      "description": description,
      "cookingDuration": cookingDuration.toString(),
      "images": images,
      "videos": videos,
      "videoExtensions": videoExtensions,
      "ingredients": ingredients?.map((e) => e.toJson()).toList(),
      "steps": steps?.map((e) => e.step).toList(),
    };
  }
}
