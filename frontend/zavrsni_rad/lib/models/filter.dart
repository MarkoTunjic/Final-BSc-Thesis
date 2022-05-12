class Filter {
  int? authorId;
  int index;
  String? orderBy;
  String? nameLike;
  int? maxCookingDuration;
  List<String>? canContainIngredients;
  List<String>? mustNotContainIngredients;

  Filter({
    required this.index,
    this.canContainIngredients,
    this.maxCookingDuration,
    this.mustNotContainIngredients,
    this.nameLike,
    this.orderBy,
    this.authorId,
  });

  Map<String, dynamic> toJson() {
    return {
      "authorId": authorId,
      "index": index,
      "orderBy": orderBy,
      "nameLike": nameLike,
      "maxCookingDuration": maxCookingDuration,
      "canContainIngredients": canContainIngredients,
      "mustNotContainIngredients": mustNotContainIngredients,
    };
  }
}
