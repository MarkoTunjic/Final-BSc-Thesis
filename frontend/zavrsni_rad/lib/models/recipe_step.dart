class RecipeStep {
  String step;
  int? orderNumber;

  RecipeStep({required this.step, this.orderNumber});

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
        step: json["stepDescription"], orderNumber: json["orderNumber"]);
  }

  Map<String, dynamic> toJson() {
    return {"step": step};
  }
}
