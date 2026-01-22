import 'package:freezed_annotation/freezed_annotation.dart';

part 'service.freezed.dart';
part 'service.g.dart';

@freezed
abstract class Service with _$Service {
  const factory Service({
    required String id,
    required String mechanicName,
    required String profileImageUrl,
    required List<String> services, // e.g., ["Engine repair", "Maintenance"]
    required double rating,
    int? reviewCount,
    String? description,
    String? phoneNumber,
    String? email,
    String? location,
    @Default(true) bool isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Service;

  factory Service.fromJson(Map<String, Object?> json) => _$ServiceFromJson(
    json);
}