import 'package:flutter/material.dart';
import '../../data/models/daily_nutrition_record.dart';
import '../../core/services/nutrition_analysis_service.dart';
import '../widget/common/nutrition_risk_alert_dialog.dart';

/// 달력 화면 - 일일 영양소 달성률 표시
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  Map<String, DailyNutritionRecord> _nutritionRecords = {};

  @override
  void initState() {
    super.initState();
    _loadNutritionRecords();
  }

  /// 영양소 기록 로드 (임시 데이터)
  void _loadNutritionRecords() {
    // 실제로는 SharedPreferences나 데이터베이스에서 로드
    _nutritionRecords = _generateSampleData();
  }

  /// 샘플 데이터 생성
  Map<String, DailyNutritionRecord> _generateSampleData() {
    final records = <String, DailyNutritionRecord>{};
    final now = DateTime.now();

    // 최근 30일간의 샘플 데이터 생성
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final dateKey = _getDateKey(date);

      // 랜덤한 영양소 데이터 생성
      final nutritionData = {
        'calories': (1500 + (i * 50) + (i % 3 * 100)).toDouble(),
        'protein': (30 + (i % 2 * 20) + (i % 5 * 10)).toDouble(),
        'carbs': (200 + (i % 4 * 50) + (i % 3 * 30)).toDouble(),
        'fat': (40 + (i % 3 * 15) + (i % 2 * 10)).toDouble(),
        'fiber': (15 + (i % 2 * 8) + (i % 4 * 5)).toDouble(),
        'sugar': (20 + (i % 3 * 15) + (i % 2 * 10)).toDouble(),
      };

      final risks =
          NutritionAnalysisService.analyzeNutritionRisks(nutritionData);
      final overallProgress =
          NutritionAnalysisService.calculateOverallProgress(nutritionData);

      records[dateKey] = DailyNutritionRecord(
        date: date,
        nutritionData: nutritionData,
        overallProgress: overallProgress,
        risks: risks,
        isCompleted: i % 4 != 0, // 25% 확률로 기록 없음
      );
    }

    return records;
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영양소 달성률 달력'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 월 선택 헤더
          _buildMonthHeader(),

          // 달력 그리드
          Expanded(
            child: _buildCalendarGrid(),
          ),

          // 범례
          _buildLegend(),

          // 선택된 날짜 상세 정보
          _buildSelectedDateInfo(),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _currentMonth =
                    DateTime(_currentMonth.year, _currentMonth.month - 1);
              });
            },
            icon: const Icon(Icons.chevron_left, color: Colors.white),
          ),
          Text(
            '${_currentMonth.year}년 ${_currentMonth.month}월',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _currentMonth =
                    DateTime(_currentMonth.year, _currentMonth.month + 1);
              });
            },
            icon: const Icon(Icons.chevron_right, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstDayOfWeek = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    // 요일 헤더
    final weekdays = ['월', '화', '수', '목', '금', '토', '일'];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 요일 헤더
          Row(
            children: weekdays.map((weekday) {
              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    weekday,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          // 달력 그리드
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.2,
              ),
              itemCount: firstDayOfWeek - 1 + daysInMonth,
              itemBuilder: (context, index) {
                if (index < firstDayOfWeek - 1) {
                  // 빈 공간
                  return const SizedBox();
                }

                final day = index - firstDayOfWeek + 2;
                final date =
                    DateTime(_currentMonth.year, _currentMonth.month, day);
                final dateKey = _getDateKey(date);
                final record = _nutritionRecords[dateKey];

                return _buildCalendarDay(date, record);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(DateTime date, DailyNutritionRecord? record) {
    final isToday = _isSameDay(date, DateTime.now());
    final isSelected = _isSameDay(date, _selectedDate);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _getDayBackgroundColor(record, isSelected, isToday),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: _getDayTextColor(record, isSelected, isToday),
              ),
            ),
            if (record != null) ...[
              const SizedBox(height: 2),
              _buildDayIndicator(record),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDayIndicator(DailyNutritionRecord record) {
    if (!record.isCompleted) {
      return const Icon(
        Icons.remove,
        size: 12,
        color: Colors.grey,
      );
    }

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: _getStatusColor(record.nutritionStatus),
        shape: BoxShape.circle,
      ),
    );
  }

  Color _getDayBackgroundColor(
      DailyNutritionRecord? record, bool isSelected, bool isToday) {
    if (isSelected) return Colors.orange.withOpacity(0.2);
    if (isToday) return Colors.orange.withOpacity(0.1);
    if (record == null) return Colors.grey.withOpacity(0.1);
    return Colors.transparent;
  }

  Color _getDayTextColor(
      DailyNutritionRecord? record, bool isSelected, bool isToday) {
    if (isSelected) return Colors.orange;
    if (isToday) return Colors.orange;
    if (record == null) return Colors.grey;
    return Colors.black87;
  }

  Color _getStatusColor(NutritionStatus status) {
    switch (status) {
      case NutritionStatus.notRecorded:
        return Colors.grey;
      case NutritionStatus.poor:
        return Colors.red;
      case NutritionStatus.fair:
        return Colors.orange;
      case NutritionStatus.good:
        return Colors.blue;
      case NutritionStatus.excellent:
        return Colors.green;
    }
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem(Colors.grey, '기록없음'),
          _buildLegendItem(Colors.red, '부족'),
          _buildLegendItem(Colors.orange, '보통'),
          _buildLegendItem(Colors.blue, '양호'),
          _buildLegendItem(Colors.green, '우수'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSelectedDateInfo() {
    final dateKey = _getDateKey(_selectedDate);
    final record = _nutritionRecords[dateKey];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_selectedDate.month}월 ${_selectedDate.day}일 영양소 달성률',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (record == null) ...[
            const Text(
              '이 날은 영양소 기록이 없습니다.',
              style: TextStyle(color: Colors.grey),
            ),
          ] else ...[
            // 전체 달성률
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: record.overallProgress / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getStatusColor(record.nutritionStatus),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${record.overallProgress.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 상태 표시
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getStatusColor(record.nutritionStatus),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _getStatusText(record.nutritionStatus),
                  style: const TextStyle(fontSize: 14),
                ),
                const Spacer(),
                if (record.riskCount > 0)
                  TextButton.icon(
                    onPressed: () => _showRiskDetails(record),
                    icon: const Icon(Icons.warning, size: 16),
                    label: Text('${record.riskCount}개 위험요소'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getStatusText(NutritionStatus status) {
    switch (status) {
      case NutritionStatus.notRecorded:
        return '기록 없음';
      case NutritionStatus.poor:
        return '영양소 부족';
      case NutritionStatus.fair:
        return '보통 수준';
      case NutritionStatus.good:
        return '양호한 수준';
      case NutritionStatus.excellent:
        return '우수한 수준';
    }
  }

  void _showRiskDetails(DailyNutritionRecord record) {
    showDialog(
      context: context,
      builder: (context) => NutritionRiskAlertDialog(
        risks: record.risks,
        overallProgress: record.overallProgress,
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
