import 'package:freezed_annotation/freezed_annotation.dart';

part 'part.freezed.dart';
part 'part.g.dart';

@freezed
abstract class Part with _$Part {
  const factory Part({
    required String id,
    required String name,
    required double price,
    required String category, // Engine, Cooling, Fuel, Propulsion
    required String brand,
    String? model,
    String? description,
    String? imageUrl,
    @Default(false) bool isSponsored,
    double? rating,
    int? reviewCount,
    @Default(true) bool inStock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Part;

  factory Part.fromJson(Map<String, Object?> json) => _$PartFromJson(json);
}