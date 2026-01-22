import 'package:freezed_annotation/freezed_annotation.dart';
part 'event.freezed.dart';
part 'event.g.dart';

@freezed
abstract class Event with _$Event {
  const factory Event({
    required String id,
    required String name,
    required String eventType, // Party, Birthday, Gala
    required double bookingPrice,
    required String organizerId, String? category, // Yacht Tour, Boat Cruise
    String? duration, // e.g., "2-3 hours"
    String? guide, // e.g., "Live tour guide"
    String? location,
    String? departureLocation, // Lousail, Pearl, Box park
    String? description,
    @Default([]) List<String> imageUrls,
    @Default(false) bool includesFoodAndDrinks,
    @Default('Public') String accessType, // Public, Private
    String? organizerName,
    DateTime? eventDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Event;

  factory Event.fromJson(Map<String, Object?> json) => _$EventFromJson(json);
}