/// 음식 상세정보 모델
class FoodDetail {
  final String name;
  final String category;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final NutritionInfo nutrition;
  final List<String> benefits;
  final List<String> cookingTips;
  final int preparationTime; // 분 단위
  final String difficulty; // 쉬움, 보통, 어려움

  const FoodDetail({
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.nutrition,
    required this.benefits,
    required this.cookingTips,
    required this.preparationTime,
    required this.difficulty,
  });
}

/// 영양정보 모델
class NutritionInfo {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;
  final double vitaminC;
  final double iron;

  const NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
    required this.vitaminC,
    required this.iron,
  });
}

/// 음식 데이터 서비스
class FoodDataService {
  static final Map<String, FoodDetail> _foodDatabase = {
    '샐러드': const FoodDetail(
      name: '그린 샐러드',
      category: '샐러드',
      description: '신선한 채소로 만든 건강한 샐러드입니다. 다양한 비타민과 미네랄이 풍부합니다.',
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
      ingredients: ['양상추', '토마토', '오이', '당근', '올리브오일', '레몬즙'],
      nutrition: NutritionInfo(
        calories: 120,
        protein: 3.5,
        carbs: 15.2,
        fat: 5.8,
        fiber: 4.2,
        sugar: 8.1,
        sodium: 180,
        vitaminC: 45.2,
        iron: 1.8,
      ),
      benefits: [
        '비타민과 미네랄 공급',
        '소화 건강 개선',
        '체중 관리에 도움',
        '항산화 효과',
      ],
      cookingTips: [
        '채소는 먹기 직전에 씻어서 신선함 유지',
        '드레싱은 따로 준비해서 필요할 때만 사용',
        '견과류나 치즈를 추가하면 단백질 보충',
      ],
      preparationTime: 10,
      difficulty: '쉬움',
    ),
    '과일': const FoodDetail(
      name: '믹스 과일',
      category: '과일',
      description: '계절에 맞는 다양한 과일을 조합한 건강한 간식입니다.',
      imageUrl:
          'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400',
      ingredients: ['사과', '바나나', '딸기', '포도', '키위', '오렌지'],
      nutrition: NutritionInfo(
        calories: 95,
        protein: 1.2,
        carbs: 24.8,
        fat: 0.3,
        fiber: 3.1,
        sugar: 19.2,
        sodium: 2,
        vitaminC: 58.7,
        iron: 0.4,
      ),
      benefits: [
        '비타민C 풍부',
        '자연 당분 공급',
        '항산화 물질 함유',
        '소화 촉진',
      ],
      cookingTips: [
        '과일은 먹기 직전에 자르기',
        '레몬즙을 뿌리면 변색 방지',
        '신선한 과일 선택하기',
      ],
      preparationTime: 5,
      difficulty: '쉬움',
    ),
    '단백질': const FoodDetail(
      name: '그릴 치킨',
      category: '단백질',
      description: '고단백, 저지방의 건강한 단백질 공급원입니다.',
      imageUrl:
          'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=400',
      ingredients: ['닭가슴살', '올리브오일', '마늘', '로즈마리', '소금', '후추'],
      nutrition: NutritionInfo(
        calories: 165,
        protein: 31.0,
        carbs: 0.0,
        fat: 3.6,
        fiber: 0.0,
        sugar: 0.0,
        sodium: 74,
        vitaminC: 0.0,
        iron: 1.0,
      ),
      benefits: [
        '고단백, 저지방',
        '근육 형성에 도움',
        '포만감 지속',
        '체중 관리 효과',
      ],
      cookingTips: [
        '미리 양념에 재워두기',
        '중간 불에서 천천히 구우기',
        '과도한 조리 피하기',
      ],
      preparationTime: 25,
      difficulty: '보통',
    ),
    '비타민': const FoodDetail(
      name: '비타민 보울',
      category: '비타민',
      description: '다양한 비타민이 풍부한 건강식입니다.',
      imageUrl:
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400',
      ingredients: ['브로콜리', '시금치', '당근', '피망', '아보카도', '견과류'],
      nutrition: NutritionInfo(
        calories: 180,
        protein: 8.5,
        carbs: 22.3,
        fat: 7.2,
        fiber: 8.9,
        sugar: 12.1,
        sodium: 95,
        vitaminC: 89.4,
        iron: 3.2,
      ),
      benefits: [
        '비타민A, C, K 풍부',
        '엽산 함량 높음',
        '항산화 효과',
        '면역력 향상',
      ],
      cookingTips: [
        '채소는 살짝만 익히기',
        '다양한 색깔의 채소 선택',
        '견과류로 식감과 영양 보완',
      ],
      preparationTime: 15,
      difficulty: '쉬움',
    ),
    '건강식': const FoodDetail(
      name: '퀴노아 보울',
      category: '건강식',
      description: '슈퍼푸드 퀴노아를 활용한 균형잡힌 건강식입니다.',
      imageUrl:
          'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400',
      ingredients: ['퀴노아', '시금치', '체리토마토', '아보카도', '견과류', '올리브오일'],
      nutrition: NutritionInfo(
        calories: 220,
        protein: 8.1,
        carbs: 35.2,
        fat: 6.8,
        fiber: 5.2,
        sugar: 4.1,
        sodium: 45,
        vitaminC: 23.4,
        iron: 2.8,
      ),
      benefits: [
        '완전단백질 함유',
        '식이섬유 풍부',
        '글루텐 프리',
        '항산화 물질',
      ],
      cookingTips: [
        '퀴노아는 미리 씻어서 쓴맛 제거',
        '물과 비율 1:2로 조리',
        '다양한 채소와 조합',
      ],
      preparationTime: 20,
      difficulty: '보통',
    ),
    '다이어트': const FoodDetail(
      name: '저칼로리 보울',
      category: '다이어트',
      description: '칼로리는 낮지만 영양은 풍부한 다이어트 식사입니다.',
      imageUrl:
          'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=400',
      ingredients: ['양배추', '오이', '토마토', '단백질', '레몬즙', '허브'],
      nutrition: NutritionInfo(
        calories: 85,
        protein: 6.2,
        carbs: 12.8,
        fat: 1.2,
        fiber: 4.5,
        sugar: 8.9,
        sodium: 25,
        vitaminC: 67.8,
        iron: 1.2,
      ),
      benefits: [
        '저칼로리, 고영양',
        '포만감 제공',
        '신진대사 촉진',
        '체중 감량 효과',
      ],
      cookingTips: [
        '칼로리 낮은 드레싱 사용',
        '단백질로 포만감 증대',
        '충분한 수분 섭취',
      ],
      preparationTime: 12,
      difficulty: '쉬움',
    ),
  };

  /// 태그로 음식 정보를 가져옵니다
  static FoodDetail? getFoodByTag(String tag) {
    return _foodDatabase[tag];
  }

  /// 모든 음식 카테고리를 가져옵니다
  static List<String> getAllCategories() {
    return _foodDatabase.values.map((food) => food.category).toSet().toList();
  }

  /// 카테고리별 음식 목록을 가져옵니다
  static List<FoodDetail> getFoodsByCategory(String category) {
    return _foodDatabase.values
        .where((food) => food.category == category)
        .toList();
  }
}
