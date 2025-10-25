import 'package:equatable/equatable.dart';

/// 음식 정보 엔티티
class FoodInfo extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String category;
  final List<String> ingredients;
  final int calories;
  final double rating;
  final int reviewCount;

  const FoodInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.ingredients,
    required this.calories,
    required this.rating,
    required this.reviewCount,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        price,
        category,
        ingredients,
        calories,
        rating,
        reviewCount,
      ];
}
