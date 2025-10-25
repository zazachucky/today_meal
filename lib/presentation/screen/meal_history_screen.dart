import 'package:flutter/material.dart';
import '../../core/services/nutrition_data_service.dart';

/// 식사 기록 화면
class MealHistoryScreen extends StatefulWidget {
  const MealHistoryScreen({super.key});

  @override
  State<MealHistoryScreen> createState() => _MealHistoryScreenState();
}

class _MealHistoryScreenState extends State<MealHistoryScreen> {
  List<NutritionData> _nutritionDataList = [];
  bool _isLoading = true;
  String _selectedDate = '';

  @override
  void initState() {
    super.initState();
    _loadNutritionData();
  }

  Future<void> _loadNutritionData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dataList = await NutritionDataService.getNutritionDataList();
      setState(() {
        _nutritionDataList = dataList;
        _selectedDate = dataList.isNotEmpty ? dataList.first.date : '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('데이터를 불러오는 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('식사 기록'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _nutritionDataList.isEmpty
              ? _buildEmptyState()
              : _buildNutritionDataList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '식사 기록이 없습니다',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '영양소 입력을 통해\n식사 기록을 시작해보세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionDataList() {
    return Column(
      children: [
        // 날짜 선택기
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.orange),
              const SizedBox(width: 8),
              const Text(
                '날짜 선택:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedDate,
                  isExpanded: true,
                  underline: Container(
                    height: 1,
                    color: Colors.orange,
                  ),
                  items: _nutritionDataList.map((data) {
                    return DropdownMenuItem<String>(
                      value: data.date,
                      child: Text(_formatDate(data.date)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedDate = newValue;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),

        // 선택된 날짜의 영양소 데이터 표시
        Expanded(
          child: _buildNutritionDetails(),
        ),
      ],
    );
  }

  Widget _buildNutritionDetails() {
    final selectedData = _nutritionDataList.firstWhere(
      (data) => data.date == _selectedDate,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 날짜 헤더
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  _formatDate(selectedData.date),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '영양소 섭취량',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 주요 영양소
          _buildNutritionSection(
            title: '주요 영양소',
            icon: Icons.local_fire_department,
            color: Colors.orange,
            items: [
              _buildNutritionItem(
                  '칼로리', '${selectedData.calories.toStringAsFixed(0)}', 'kcal'),
              _buildNutritionItem(
                  '단백질', '${selectedData.protein.toStringAsFixed(1)}', 'g'),
              _buildNutritionItem(
                  '탄수화물', '${selectedData.carbs.toStringAsFixed(1)}', 'g'),
              _buildNutritionItem(
                  '지방', '${selectedData.fat.toStringAsFixed(1)}', 'g'),
            ],
          ),

          const SizedBox(height: 16),

          // 미네랄
          _buildNutritionSection(
            title: '미네랄',
            icon: Icons.science,
            color: Colors.blue,
            items: [
              _buildNutritionItem(
                  '나트륨', '${selectedData.sodium.toStringAsFixed(0)}', 'mg'),
              _buildNutritionItem(
                  '칼슘', '${selectedData.calcium.toStringAsFixed(0)}', 'mg'),
              _buildNutritionItem(
                  '철분', '${selectedData.iron.toStringAsFixed(1)}', 'mg'),
            ],
          ),

          const SizedBox(height: 16),

          // 비타민 및 기타
          _buildNutritionSection(
            title: '비타민 및 기타',
            icon: Icons.eco,
            color: Colors.green,
            items: [
              _buildNutritionItem(
                  '비타민C', '${selectedData.vitaminC.toStringAsFixed(0)}', 'mg'),
              _buildNutritionItem(
                  '식이섬유', '${selectedData.fiber.toStringAsFixed(1)}', 'g'),
              _buildNutritionItem(
                  '당분', '${selectedData.sugar.toStringAsFixed(1)}', 'g'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items,
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String name, String value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return '오늘';
    } else if (targetDate == today.subtract(const Duration(days: 1))) {
      return '어제';
    } else {
      return '${date.month}월 ${date.day}일';
    }
  }
}
