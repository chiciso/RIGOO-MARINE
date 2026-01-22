import 'package:freezed_annotation/freezed_annotation.dart';

part 'listing.freezed.dart';
part 'listing.g.dart';

@freezed
abstract class Listing with _$Listing {
  const factory Listing({
    required String id,
    required String name,
    required String itemType, // Boat, Yacht, Jet Ski
    required double price,
    required String condition, // New, Used - Perfect, Used - Good
    required String category,
    required String sellerId, // Boats, Yachts, Jetskis
    String? engineModel,
    String? bodyModel,
    String? engineType,
    String? enginePower,
    String? engineHours,
    String? bodyLength,
    String? description,
    String? address,
    @Default([]) List<String> imageUrls,
    String? sellerName,
    @Default('For Sale') String listingType, // For Sale, For Rent, For Charter
    @Default(false) bool isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Listing;

  factory Listing.fromJson(Map<String, dynamic> json) =>_$ListingFromJson(json);
}