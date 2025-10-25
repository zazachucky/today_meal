import 'package:flutter/material.dart';
import '../../../data/models/food_detail_model.dart';
import '../../screen/food_detail_screen.dart';
import '../common/no_search_result_dialog.dart';

/// 검색창 위젯
class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      // 태그에 해당하는 음식 상세정보가 있는지 확인
      final foodDetail = FoodDataService.getFoodByTag(query.trim());

      if (foodDetail != null) {
        // 음식 상세정보 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailScreen(foodDetail: foodDetail),
          ),
        );
      } else {
        // 검색 결과 없음 알럿 표시
        _showNoSearchResultDialog(query.trim());
      }
    }
  }

  void _showNoSearchResultDialog(String query) {
    showDialog(
      context: context,
      builder: (context) => NoSearchResultDialog(searchQuery: query),
    ).then((selectedTag) {
      // 사용자가 추천 태그를 선택한 경우
      if (selectedTag != null && selectedTag is String) {
        _searchController.text = selectedTag;
        _onSearchSubmitted(selectedTag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '음식 검색',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
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
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: '음식명이나 재료를 검색해보세요',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.orange,
                      size: 24,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.grey,
                              size: 20,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  onSubmitted: _onSearchSubmitted,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _searchController.text.trim().isNotEmpty
                  ? () => _onSearchSubmitted(_searchController.text)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _searchController.text.trim().isNotEmpty
                    ? Colors.orange
                    : Colors.grey[300],
                foregroundColor: _searchController.text.trim().isNotEmpty
                    ? Colors.white
                    : Colors.grey[500],
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: _searchController.text.trim().isNotEmpty ? 2 : 0,
              ),
              child: Icon(
                Icons.search,
                size: 24,
                color: _searchController.text.trim().isNotEmpty
                    ? Colors.white
                    : Colors.grey[500],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 빠른 검색 태그들
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            '샐러드',
            '과일',
            '단백질',
            '비타민',
            '건강식',
            '다이어트',
          ]
              .map((tag) => GestureDetector(
                    onTap: () {
                      _searchController.text = tag;
                      _onSearchSubmitted(tag);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
