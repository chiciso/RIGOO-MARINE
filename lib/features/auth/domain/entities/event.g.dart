// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Event _$EventFromJson(Map<String, dynamic> json) => _Event(
  id: json['id'] as String,
  name: json['name'] as String,
  eventType: json['eventType'] as String,
  bookingPrice: (json['bookingPrice'] as num).toDouble(),
  organizerId: json['organizerId'] as String,
  category: json['category'] as String?,
  duration: json['duration'] as String?,
  guide: json['guide'] as String?,
  location: json['location'] as String?,
  departureLocation: json['departureLocation'] as String?,
  description: json['description'] as String?,
  imageUrls:
      (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  includesFoodAndDrinks: json['includesFoodAndDrinks'] as bool? ?? false,
  accessType: json['accessType'] as String? ?? 'Public',
  organizerName: json['organizerName'] as String?,
  eventDate: json['eventDate'] == null
      ? null
      : DateTime.parse(json['eventDate'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$EventToJson(_Event instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'eventType': instance.eventType,
  'bookingPrice': instance.bookingPrice,
  'organizerId': instance.organizerId,
  'category': instance.category,
  'duration': instance.duration,
  'guide': instance.guide,
  'location': instance.location,
  'departureLocation': instance.departureLocation,
  'description': instance.description,
  'imageUrls': instance.imageUrls,
  'includesFoodAndDrinks': instance.includesFoodAndDrinks,
  'accessType': instance.accessType,
  'organizerName': instance.organizerName,
  'eventDate': instance.eventDate?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
