class Filter {
  int index;
  String? orderBy;
  String? nameLike;
  int? maxCookingDuration;
  List<String>? canContainIngredients;
  List<String>? mustNotContaintIngredients;

  Filter({
    required this.index,
    this.canContainIngredients,
    this.maxCookingDuration,
    this.mustNotContaintIngredients,
    this.nameLike,
    this.orderBy,
  });

  Map<String, dynamic> toJson() {
    return {
      "index": index,
      "orderBy": orderBy,
      "nameLike": nameLike,
      "maxCookingDuration": maxCookingDuration,
      "canContainIngredients": canContainIngredients,
      "mustNotContaintIngredients": mustNotContaintIngredients,
    };
  }
}
