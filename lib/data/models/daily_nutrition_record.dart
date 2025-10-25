import '../../core/services/nutrition_analysis_service.dart';

/// 일일 영양소 기록 모델
class DailyNutritionRecord {
  final DateTime date;
  final Map<String, double> nutritionData;
  final double overallProgress;
  final List<NutritionRisk> risks;
  final bool isCompleted;

  const DailyNutritionRecord({
    required this.date,
    required this.nutritionData,
    required this.overallProgress,
    required this.risks,
    required this.isCompleted,
  });

  /// 영양소 달성 상태
  NutritionStatus get nutritionStatus {
    if (!isCompleted) return NutritionStatus.notRecorded;
    if (overallProgress >= 80) return NutritionStatus.excellent;
    if (overallProgress >= 60) return NutritionStatus.good;
    if (overallProgress >= 40) return NutritionStatus.fair;
    return NutritionStatus.poor;
  }

  /// 위험 영양소 개수
  int get riskCount => risks.length;

  /// 심각한 위험 영양소 개수
  int get severeRiskCount =>
      risks.where((risk) => risk.severity == 'danger').length;

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'nutritionData': nutritionData,
      'overallProgress': overallProgress,
      'risks': risks
          .map((risk) => {
                'nutrient': risk.nutrient,
                'riskType': risk.riskType,
                'message': risk.message,
                'severity': risk.severity,
                'currentValue': risk.currentValue,
                'targetValue': risk.targetValue,
                'percentage': risk.percentage,
              })
          .toList(),
      'isCompleted': isCompleted,
    };
  }

  factory DailyNutritionRecord.fromJson(Map<String, dynamic> json) {
    return DailyNutritionRecord(
      date: DateTime.parse(json['date']),
      nutritionData: Map<String, double>.from(json['nutritionData']),
      overallProgress: json['overallProgress'].toDouble(),
      risks: (json['risks'] as List)
          .map((riskJson) => NutritionRisk(
                nutrient: riskJson['nutrient'],
                riskType: riskJson['riskType'],
                message: riskJson['message'],
                severity: riskJson['severity'],
                currentValue: riskJson['currentValue'].toDouble(),
                targetValue: riskJson['targetValue'].toDouble(),
                percentage: riskJson['percentage'].toDouble(),
              ))
          .toList(),
      isCompleted: json['isCompleted'],
    );
  }
}

/// 영양소 달성 상태
enum NutritionStatus {
  notRecorded, // 기록 없음
  poor, // 부족 (40% 미만)
  fair, // 보통 (40-60%)
  good, // 양호 (60-80%)
  excellent, // 우수 (80% 이상)
}

// NutritionRisk는 core/services/nutrition_analysis_service.dart에서 import
