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
  String? video;
  String? videoExtension;
  List<Ingredient>? ingredients;

  NewRecipe({
    this.userId,
    this.cookingDuration,
    this.coverPicture,
    this.recipeName,
    this.description,
    this.images,
    this.video,
    this.ingredients,
    this.videoExtension,
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
      "video": video,
      "videoExtension": videoExtension,
      "ingredients": ingredients?.map((e) => e.toJson()).toList(),
      "steps": steps?.map((e) => e.step).toList(),
    };
  }
}
