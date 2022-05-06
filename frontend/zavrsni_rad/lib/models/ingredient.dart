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
}
