import 'package:flutter/material.dart';
import 'dart:async';

/// 건강데이터 배너 이미지 롤링 위젯
class HealthDataBannerWidget extends StatefulWidget {
  const HealthDataBannerWidget({super.key});

  @override
  State<HealthDataBannerWidget> createState() => _HealthDataBannerWidgetState();
}

class _HealthDataBannerWidgetState extends State<HealthDataBannerWidget> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;

  final List<HealthBannerData> _bannerData = [
    HealthBannerData(
      title: '오늘의 칼로리',
      value: '1,850',
      unit: 'kcal',
      icon: Icons.local_fire_department,
      color: Colors.orange,
      description: '목표 대비 85%',
    ),
    HealthBannerData(
      title: '단백질 섭취량',
      value: '65',
      unit: 'g',
      icon: Icons.fitness_center,
      color: Colors.blue,
      description: '권장량 달성',
    ),
    HealthBannerData(
      title: '수분 섭취량',
      value: '1.8',
      unit: 'L',
      icon: Icons.water_drop,
      color: Colors.cyan,
      description: '목표 대비 90%',
    ),
    HealthBannerData(
      title: '운동 시간',
      value: '45',
      unit: '분',
      icon: Icons.directions_run,
      color: Colors.green,
      description: '오늘의 목표 달성',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _currentIndex = (_currentIndex + 1) % _bannerData.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // 배너 제목
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: Colors.orange,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  '오늘의 건강 데이터',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 배너 롤링 영역
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: _bannerData.length,
              itemBuilder: (context, index) {
                final data = _bannerData[index];
                return _buildBannerCard(data);
              },
            ),
          ),

          // 페이지 인디케이터
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _bannerData.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? Colors.orange
                      : Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCard(HealthBannerData data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            data.color.withOpacity(0.1),
            data.color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: data.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // 아이콘
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: data.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                data.icon,
                color: data.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // 데이터 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        data.value,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: data.color,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        data.unit,
                        style: TextStyle(
                          fontSize: 12,
                          color: data.color.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    data.description,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // 화살표 아이콘
            Icon(
              Icons.arrow_forward_ios,
              color: data.color.withOpacity(0.5),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

/// 건강 배너 데이터 모델
class HealthBannerData {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final String description;

  HealthBannerData({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.description,
  });
}
