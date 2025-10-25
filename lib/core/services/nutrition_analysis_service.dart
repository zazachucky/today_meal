import '../constants/app_constants.dart';

/// 영양소 분석 결과 모델
class NutritionRisk {
  final String nutrient;
  final String riskType;
  final String message;
  final String severity;
  final double currentValue;
  final double targetValue;
  final double percentage;

  const NutritionRisk({
    required this.nutrient,
    required this.riskType,
    required this.message,
    required this.severity,
    required this.currentValue,
    required this.targetValue,
    required this.percentage,
  });
}

/// 영양소 분석 서비스
class NutritionAnalysisService {
  /// 입력된 영양소 데이터를 분석하여 위험요소를 찾습니다
  static List<NutritionRisk> analyzeNutritionRisks(
      Map<String, double> nutritionData) {
    final List<NutritionRisk> risks = [];

    for (final entry in nutritionData.entries) {
      final nutrient = entry.key;
      final currentValue = entry.value;
      final targetValue = AppConstants.dailyNutritionTargets[nutrient];

      if (targetValue == null || currentValue == 0) continue;

      final percentage = currentValue / targetValue;

      switch (nutrient) {
        case 'protein':
          _checkProteinRisk(risks, currentValue, targetValue, percentage);
          break;
        case 'carbs':
          _checkCarbsRisk(risks, currentValue, targetValue, percentage);
          break;
        case 'fat':
          _checkFatRisk(risks, currentValue, targetValue, percentage);
          break;
        case 'fiber':
          _checkFiberRisk(risks, currentValue, targetValue, percentage);
          break;
        case 'sugar':
          _checkSugarRisk(risks, currentValue, targetValue, percentage);
          break;
      }
    }

    return risks;
  }

  /// 단백질 위험요소 체크
  static void _checkProteinRisk(List<NutritionRisk> risks, double currentValue,
      double targetValue, double percentage) {
    if (percentage < AppConstants.nutritionRiskThresholds['protein_low']!) {
      risks.add(NutritionRisk(
        nutrient: '단백질',
        riskType: '부족',
        message:
            '단백질 섭취가 권장량의 ${(percentage * 100).toStringAsFixed(1)}%로 부족합니다. 근육 건강을 위해 단백질 섭취를 늘려보세요.',
        severity: 'warning',
        currentValue: currentValue,
        targetValue: targetValue,
        percentage: percentage,
      ));
    } else if (percentage >
        AppConstants.nutritionRiskThresholds['protein_high']!) {
      risks.add(NutritionRisk(
        nutrient: '단백질',
        riskType: '과다',
        message:
            '단백질 섭취가 권장량의 ${(percentage * 100).toStringAsFixed(1)}%로 과다합니다. 신장 건강을 위해 단백질 섭취를 줄여보세요.',
        severity: 'danger',
        currentValue: currentValue,
        targetValue: targetValue,
        percentage: percentage,
      ));
    }
  }

  /// 탄수화물 위험요소 체크
  static void _checkCarbsRisk(List<NutritionRisk> risks, double currentValue,
      double targetValue, double percentage) {
    if (percentage < AppConstants.nutritionRiskThresholds['carbs_low']!) {
      risks.add(NutritionRisk(
        nutrient: '탄수화물',
        riskType: '부족',
        message:
            '탄수화물 섭취가 권장량의 ${(percentage * 100).toStringAsFixed(1)}%로 부족합니다. 에너지 공급을 위해 탄수화물 섭취를 늘려보세요.',
        severity: 'warning',
        currentValue: currentValue,
        targetValue: targetValue,
        percentage: percentage,
      ));
    } else if (percentage >
        AppConstants.nutritionRiskThresholds['carbs_high']!) {
      risks.add(NutritionRisk(
        nutrient: '탄수화물',
        riskType: '과다',
        message:
            '탄수화물 섭취가 권장량의 ${(percentage * 100).toStringAsFixed(1)}%로 과다합니다. 혈당 관리를 위해 탄수화물 섭취를 줄여보세요.',
        severity: 'danger',
        currentValue: currentValue,
        targetValue: targetValue,
        percentage: percentage,
      ));
    }
  }

  /// 지방 위험요소 체크
  static void _checkFatRisk(List<NutritionRisk> risks, double currentValue,
      double targetValue, double percentage) {
    if (percentage < AppConstants.nutritionRiskThresholds['fat_low']!) {
      risks.add(NutritionRisk(
        nutrient: '지방',
        riskType: '부족',
        message:
            '지방 섭취가 권장량의 ${(percentage * 100).toStringAsFixed(1)}%로 부족합니다. 호르몬 생성을 위해 건강한 지방 섭취를 늘려보세요.',
        severity: 'warning',
        currentValue: currentValue,
        targetValue: targetValue,
        percentage: percentage,
      ));
    } else if (percentage > AppConstants.nutritionRiskThresholds['fat_high']!) {
      risks.add(NutritionRisk(
        nutrient: '지방',
        riskType: '과다',
        message:
            '지방 섭취가 권장량의 ${(percentage * 100).toStringAsFixed(1)}%로 과다합니다. 심혈관 건강을 위해 지방 섭취를 줄여보세요.',
        severity: 'danger',
        currentValue: currentValue,
        targetValue: targetValue,
        percentage: percentage,
      ));
    }
  }

  /// 식이섬유 위험요소 체크
  static void _checkFiberRisk(List<NutritionRisk> risks, double currentValue,
      double targetValue, double percentage) {
    if (percentage < AppConstants.nutritionRiskThresholds['fiber_low']!) {
      risks.add(NutritionRisk(
        nutrient: '식이섬유',
        riskType: '부족',
        message:
            '식이섬유 섭취가 권장량의 ${(percentage * 100).toStringAsFixed(1)}%로 부족합니다. 소화 건강을 위해 채소와 과일 섭취를 늘려보세요.',
        severity: 'warning',
        currentValue: currentValue,
        targetValue: targetValue,
        percentage: percentage,
      ));
    }
  }

  /// 당분 위험요소 체크
  static void _checkSugarRisk(List<NutritionRisk> risks, double currentValue,
      double targetValue, double percentage) {
    if (percentage > AppConstants.nutritionRiskThresholds['sugar_high']!) {
      risks.add(NutritionRisk(
        nutrient: '당분',
        riskType: '과다',
        message:
            '당분 섭취가 권장량의 ${(percentage * 100).toStringAsFixed(1)}%로 과다합니다. 당뇨병 예방을 위해 당분 섭취를 줄여보세요.',
        severity: 'danger',
        currentValue: currentValue,
        targetValue: targetValue,
        percentage: percentage,
      ));
    }
  }

  /// 전체 영양소 목표 달성률 계산
  static double calculateOverallProgress(Map<String, double> nutritionData) {
    double totalProgress = 0;
    int validNutrients = 0;

    for (final entry in nutritionData.entries) {
      final nutrient = entry.key;
      final currentValue = entry.value;
      final targetValue = AppConstants.dailyNutritionTargets[nutrient];

      if (targetValue != null && currentValue > 0) {
        // 각 영양소의 달성률을 계산 (100%를 넘지 않도록 제한)
        final progress = (currentValue / targetValue).clamp(0.0, 1.0);
        totalProgress += progress;
        validNutrients++;
      }
    }

    return validNutrients > 0 ? (totalProgress / validNutrients) * 100 : 0;
  }
}
