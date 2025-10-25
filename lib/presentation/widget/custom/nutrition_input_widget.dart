import 'package:flutter/material.dart';
import '../../../core/services/nutrition_analysis_service.dart';
import '../common/nutrition_risk_alert_dialog.dart';

/// 오늘 하루 섭취량 영양소 입력 위젯
class NutritionInputWidget extends StatefulWidget {
  const NutritionInputWidget({super.key});

  @override
  State<NutritionInputWidget> createState() => _NutritionInputWidgetState();
}

class _NutritionInputWidgetState extends State<NutritionInputWidget> {
  final Map<String, TextEditingController> _controllers = {
    'calories': TextEditingController(),
    'protein': TextEditingController(),
    'carbs': TextEditingController(),
    'fat': TextEditingController(),
    'fiber': TextEditingController(),
    'sugar': TextEditingController(),
  };

  double _currentProgress = 0.0;

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _saveNutritionData() {
    // 영양소 데이터 저장 로직
    final nutritionData = <String, double>{};
    _controllers.forEach((key, controller) {
      final value = double.tryParse(controller.text) ?? 0.0;
      nutritionData[key] = value;
    });

    // 영양소 분석 및 위험요소 확인
    final risks = NutritionAnalysisService.analyzeNutritionRisks(nutritionData);
    final overallProgress =
        NutritionAnalysisService.calculateOverallProgress(nutritionData);

    // 현재 진행률 업데이트
    setState(() {
      _currentProgress = overallProgress;
    });

    // 저장 완료 스낵바 표시
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('오늘의 영양소 정보가 저장되었습니다!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // 영양소 위험요소 알럿 표시
    _showNutritionRiskAlert(risks, overallProgress);

    // 입력 필드 초기화
    _controllers.values.forEach((controller) => controller.clear());
  }

  void _showNutritionRiskAlert(
      List<NutritionRisk> risks, double overallProgress) {
    showDialog(
      context: context,
      builder: (context) => NutritionRiskAlertDialog(
        risks: risks,
        overallProgress: overallProgress,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '오늘의 영양소 섭취량',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton.icon(
              onPressed: _saveNutritionData,
              icon: const Icon(
                Icons.save,
                color: Colors.orange,
                size: 20,
              ),
              label: const Text(
                '저장',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildNutritionRow('칼로리', 'calories', 'kcal'),
              const SizedBox(height: 12),
              _buildNutritionRow('단백질', 'protein', 'g'),
              const SizedBox(height: 12),
              _buildNutritionRow('탄수화물', 'carbs', 'g'),
              const SizedBox(height: 12),
              _buildNutritionRow('지방', 'fat', 'g'),
              const SizedBox(height: 12),
              _buildNutritionRow('식이섬유', 'fiber', 'g'),
              const SizedBox(height: 12),
              _buildNutritionRow('당분', 'sugar', 'g'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // 영양소 목표 달성률 표시
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.orange.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.trending_up,
                color: _getProgressColor(_currentProgress),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '오늘의 목표 달성률: ${_currentProgress.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _getProgressColor(_currentProgress),
                  ),
                ),
              ),
              Container(
                width: 60,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (_currentProgress / 100).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getProgressColor(_currentProgress),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionRow(String label, String key, String unit) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: _controllers[key],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              suffixText: unit,
              suffixStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 80) return Colors.green;
    if (progress >= 60) return Colors.orange;
    return Colors.red;
  }
}
