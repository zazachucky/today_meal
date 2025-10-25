import 'package:flutter/material.dart';

/// 메인 화면
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today Meal'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: const HomeTab(),
    );
  }
}

/// 홈 탭
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
