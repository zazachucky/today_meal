import 'package:flutter/material.dart';
import '../widget/custom/image_scroll_widget.dart';
import '../widget/custom/search_widget.dart';
import '../widget/custom/nutrition_input_widget.dart';

/// 홈 탭 화면
class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 화면 이미지 2개 로딩 스크롤
          ImageScrollWidget(),
          SizedBox(height: 24),

          // 검색창 만들기
          SearchWidget(),
          SizedBox(height: 24),

          // 오늘 하루 섭취량 영양소 입력
          NutritionInputWidget(),
          SizedBox(height: 24),

          // 기존 아이콘과 텍스트는 하단으로 이동
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.restaurant,
                  size: 80,
                  color: Colors.orange,
                ),
                SizedBox(height: 20),
                Text(
                  '오늘의 맛있는 식사',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '어떤 음식을 드시고 싶으신가요?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
