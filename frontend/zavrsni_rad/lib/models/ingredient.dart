import 'package:flutter/widgets.dart';

class Ingredient {
  String? ingredientName;
  int? quantity;
  String? measure;

  Ingredient({this.ingredientName, this.measure, this.quantity});

  Map<String, dynamic> toJson() {
    return {
      "ingredientName": ingredientName,
      "quantity": quantity.toString(),
      "measure": measure
    };
  }

  @override
  int get hashCode => hashValues(ingredientName, quantity, measure);

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    Ingredient ing = other as Ingredient;
    if (ing.ingredientName != ingredientName) return false;
    if (quantity != ing.quantity) return false;
    if (measure != ing.measure) return false;
    return true;
  }
}
