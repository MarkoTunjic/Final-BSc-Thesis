class Filter {
  int index;
  String? orderBy;
  String? nameLike;
  int? maxCookingDuration;
  List<int>? canContainIngredients;
  List<int>? mustNotContaintIngredients;

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
