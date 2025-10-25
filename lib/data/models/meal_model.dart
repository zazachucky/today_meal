class Meals {
  final List<MealModel> meals;
  final int? pageNo;
  final int? totalCount;
  final int? numOfRows;
  final int? maxPage;

  Meals(
      {required this.meals,
      this.pageNo,
      this.totalCount,
      this.numOfRows,
      this.maxPage});

  factory Meals.fromJson(Map<String, dynamic> json) {
    var list = json['body']['items'] as List;
    List<MealModel> mealModelList =
        list.map((i) => MealModel.fromJson(i)).toList();
    int? totalCount = json['body']['totalCount'] as int?;
    int? numOfRows = json['body']['numOfRows'] as int?;
    int? maxPage;
    if (totalCount != null && numOfRows != null && numOfRows > 0) {
      maxPage = (totalCount + numOfRows - 1) ~/ numOfRows;
    }

    return Meals(
      meals: mealModelList,
      pageNo: json['body']['pageNo'] as int?,
      totalCount: totalCount,
      numOfRows: numOfRows,
      maxPage: maxPage,
    );
  }
}

class MealModel {
  final String? name;
  final String? kcal;
  final String? protein;
  final String? fat;
  final String? carbohydrate;
  final String? sugar;
  final String? sodium;

  MealModel({
    this.name,
    this.kcal,
    this.protein,
    this.fat,
    this.carbohydrate,
    this.sugar,
    this.sodium,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      name: json['FOOD_NM_KR'] as String?,
      kcal: json['AMT_NUM1'] as String?,
      protein: json['AMT_NUM3'] as String?,
      fat: json['AMT_NUM4'] as String?,
      carbohydrate: json['AMT_NUM6'] as String?,
      sugar: json['AMT_NUM7'] as String?,
      sodium: json['AMT_NUM13'] as String?,
    );
  }
}
