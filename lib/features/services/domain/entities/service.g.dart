// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Service _$ServiceFromJson(Map<String, dynamic> json) => _Service(
  id: json['id'] as String,
  mechanicName: json['mechanicName'] as String,
  profileImageUrl: json['profileImageUrl'] as String,
  services: (json['services'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  rating: (json['rating'] as num).toDouble(),
  reviewCount: (json['reviewCount'] as num?)?.toInt(),
  description: json['description'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  email: json['email'] as String?,
  location: json['location'] as String?,
  isAvailable: json['isAvailable'] as bool? ?? true,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ServiceToJson(_Service instance) => <String, dynamic>{
  'id': instance.id,
  'mechanicName': instance.mechanicName,
  'profileImageUrl': instance.profileImageUrl,
  'services': instance.services,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'description': instance.description,
  'phoneNumber': instance.phoneNumber,
  'email': instance.email,
  'location': instance.location,
  'isAvailable': instance.isAvailable,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
