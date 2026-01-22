// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Listing _$ListingFromJson(Map<String, dynamic> json) => _Listing(
  id: json['id'] as String,
  name: json['name'] as String,
  itemType: json['itemType'] as String,
  price: (json['price'] as num).toDouble(),
  condition: json['condition'] as String,
  category: json['category'] as String,
  sellerId: json['sellerId'] as String,
  engineModel: json['engineModel'] as String?,
  bodyModel: json['bodyModel'] as String?,
  engineType: json['engineType'] as String?,
  enginePower: json['enginePower'] as String?,
  engineHours: json['engineHours'] as String?,
  bodyLength: json['bodyLength'] as String?,
  description: json['description'] as String?,
  address: json['address'] as String?,
  imageUrls:
      (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  sellerName: json['sellerName'] as String?,
  listingType: json['listingType'] as String? ?? 'For Sale',
  isFeatured: json['isFeatured'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ListingToJson(_Listing instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'itemType': instance.itemType,
  'price': instance.price,
  'condition': instance.condition,
  'category': instance.category,
  'sellerId': instance.sellerId,
  'engineModel': instance.engineModel,
  'bodyModel': instance.bodyModel,
  'engineType': instance.engineType,
  'enginePower': instance.enginePower,
  'engineHours': instance.engineHours,
  'bodyLength': instance.bodyLength,
  'description': instance.description,
  'address': instance.address,
  'imageUrls': instance.imageUrls,
  'sellerName': instance.sellerName,
  'listingType': instance.listingType,
  'isFeatured': instance.isFeatured,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
