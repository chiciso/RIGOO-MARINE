// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Part _$PartFromJson(Map<String, dynamic> json) => _Part(
  id: json['id'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  category: json['category'] as String,
  brand: json['brand'] as String,
  model: json['model'] as String?,
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
  isSponsored: json['isSponsored'] as bool? ?? false,
  rating: (json['rating'] as num?)?.toDouble(),
  reviewCount: (json['reviewCount'] as num?)?.toInt(),
  inStock: json['inStock'] as bool? ?? true,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PartToJson(_Part instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'price': instance.price,
  'category': instance.category,
  'brand': instance.brand,
  'model': instance.model,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'isSponsored': instance.isSponsored,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'inStock': instance.inStock,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
