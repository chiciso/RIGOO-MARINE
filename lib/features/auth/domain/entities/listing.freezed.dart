// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Listing {

 String get id; String get name; String get itemType;// Boat, Yacht, Jet Ski
 double get price; String get condition;// New, Used - Perfect, Used - Good
 String get category; String get sellerId;// Boats, Yachts, Jetskis
 String? get engineModel; String? get bodyModel; String? get engineType; String? get enginePower; String? get engineHours; String? get bodyLength; String? get description; String? get address; List<String> get imageUrls; String? get sellerName; String get listingType;// For Sale, For Rent, For Charter
 bool get isFeatured; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Listing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListingCopyWith<Listing> get copyWith => _$ListingCopyWithImpl<Listing>(this as Listing, _$identity);

  /// Serializes this Listing to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Listing&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.itemType, itemType) || other.itemType == itemType)&&(identical(other.price, price) || other.price == price)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.category, category) || other.category == category)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.engineModel, engineModel) || other.engineModel == engineModel)&&(identical(other.bodyModel, bodyModel) || other.bodyModel == bodyModel)&&(identical(other.engineType, engineType) || other.engineType == engineType)&&(identical(other.enginePower, enginePower) || other.enginePower == enginePower)&&(identical(other.engineHours, engineHours) || other.engineHours == engineHours)&&(identical(other.bodyLength, bodyLength) || other.bodyLength == bodyLength)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.sellerName, sellerName) || other.sellerName == sellerName)&&(identical(other.listingType, listingType) || other.listingType == listingType)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,itemType,price,condition,category,sellerId,engineModel,bodyModel,engineType,enginePower,engineHours,bodyLength,description,address,const DeepCollectionEquality().hash(imageUrls),sellerName,listingType,isFeatured,createdAt,updatedAt]);

@override
String toString() {
  return 'Listing(id: $id, name: $name, itemType: $itemType, price: $price, condition: $condition, category: $category, sellerId: $sellerId, engineModel: $engineModel, bodyModel: $bodyModel, engineType: $engineType, enginePower: $enginePower, engineHours: $engineHours, bodyLength: $bodyLength, description: $description, address: $address, imageUrls: $imageUrls, sellerName: $sellerName, listingType: $listingType, isFeatured: $isFeatured, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ListingCopyWith<$Res>  {
  factory $ListingCopyWith(Listing value, $Res Function(Listing) _then) = _$ListingCopyWithImpl;
@useResult
$Res call({
 String id, String name, String itemType, double price, String condition, String category, String sellerId, String? engineModel, String? bodyModel, String? engineType, String? enginePower, String? engineHours, String? bodyLength, String? description, String? address, List<String> imageUrls, String? sellerName, String listingType, bool isFeatured, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$ListingCopyWithImpl<$Res>
    implements $ListingCopyWith<$Res> {
  _$ListingCopyWithImpl(this._self, this._then);

  final Listing _self;
  final $Res Function(Listing) _then;

/// Create a copy of Listing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? itemType = null,Object? price = null,Object? condition = null,Object? category = null,Object? sellerId = null,Object? engineModel = freezed,Object? bodyModel = freezed,Object? engineType = freezed,Object? enginePower = freezed,Object? engineHours = freezed,Object? bodyLength = freezed,Object? description = freezed,Object? address = freezed,Object? imageUrls = null,Object? sellerName = freezed,Object? listingType = null,Object? isFeatured = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,itemType: null == itemType ? _self.itemType : itemType // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,sellerId: null == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String,engineModel: freezed == engineModel ? _self.engineModel : engineModel // ignore: cast_nullable_to_non_nullable
as String?,bodyModel: freezed == bodyModel ? _self.bodyModel : bodyModel // ignore: cast_nullable_to_non_nullable
as String?,engineType: freezed == engineType ? _self.engineType : engineType // ignore: cast_nullable_to_non_nullable
as String?,enginePower: freezed == enginePower ? _self.enginePower : enginePower // ignore: cast_nullable_to_non_nullable
as String?,engineHours: freezed == engineHours ? _self.engineHours : engineHours // ignore: cast_nullable_to_non_nullable
as String?,bodyLength: freezed == bodyLength ? _self.bodyLength : bodyLength // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,sellerName: freezed == sellerName ? _self.sellerName : sellerName // ignore: cast_nullable_to_non_nullable
as String?,listingType: null == listingType ? _self.listingType : listingType // ignore: cast_nullable_to_non_nullable
as String,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Listing].
extension ListingPatterns on Listing {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Listing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Listing() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Listing value)  $default,){
final _that = this;
switch (_that) {
case _Listing():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Listing value)?  $default,){
final _that = this;
switch (_that) {
case _Listing() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String itemType,  double price,  String condition,  String category,  String sellerId,  String? engineModel,  String? bodyModel,  String? engineType,  String? enginePower,  String? engineHours,  String? bodyLength,  String? description,  String? address,  List<String> imageUrls,  String? sellerName,  String listingType,  bool isFeatured,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Listing() when $default != null:
return $default(_that.id,_that.name,_that.itemType,_that.price,_that.condition,_that.category,_that.sellerId,_that.engineModel,_that.bodyModel,_that.engineType,_that.enginePower,_that.engineHours,_that.bodyLength,_that.description,_that.address,_that.imageUrls,_that.sellerName,_that.listingType,_that.isFeatured,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String itemType,  double price,  String condition,  String category,  String sellerId,  String? engineModel,  String? bodyModel,  String? engineType,  String? enginePower,  String? engineHours,  String? bodyLength,  String? description,  String? address,  List<String> imageUrls,  String? sellerName,  String listingType,  bool isFeatured,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Listing():
return $default(_that.id,_that.name,_that.itemType,_that.price,_that.condition,_that.category,_that.sellerId,_that.engineModel,_that.bodyModel,_that.engineType,_that.enginePower,_that.engineHours,_that.bodyLength,_that.description,_that.address,_that.imageUrls,_that.sellerName,_that.listingType,_that.isFeatured,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String itemType,  double price,  String condition,  String category,  String sellerId,  String? engineModel,  String? bodyModel,  String? engineType,  String? enginePower,  String? engineHours,  String? bodyLength,  String? description,  String? address,  List<String> imageUrls,  String? sellerName,  String listingType,  bool isFeatured,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Listing() when $default != null:
return $default(_that.id,_that.name,_that.itemType,_that.price,_that.condition,_that.category,_that.sellerId,_that.engineModel,_that.bodyModel,_that.engineType,_that.enginePower,_that.engineHours,_that.bodyLength,_that.description,_that.address,_that.imageUrls,_that.sellerName,_that.listingType,_that.isFeatured,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Listing implements Listing {
  const _Listing({required this.id, required this.name, required this.itemType, required this.price, required this.condition, required this.category, required this.sellerId, this.engineModel, this.bodyModel, this.engineType, this.enginePower, this.engineHours, this.bodyLength, this.description, this.address, final  List<String> imageUrls = const [], this.sellerName, this.listingType = 'For Sale', this.isFeatured = false, this.createdAt, this.updatedAt}): _imageUrls = imageUrls;
  factory _Listing.fromJson(Map<String, dynamic> json) => _$ListingFromJson(json);

@override final  String id;
@override final  String name;
@override final  String itemType;
// Boat, Yacht, Jet Ski
@override final  double price;
@override final  String condition;
// New, Used - Perfect, Used - Good
@override final  String category;
@override final  String sellerId;
// Boats, Yachts, Jetskis
@override final  String? engineModel;
@override final  String? bodyModel;
@override final  String? engineType;
@override final  String? enginePower;
@override final  String? engineHours;
@override final  String? bodyLength;
@override final  String? description;
@override final  String? address;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override final  String? sellerName;
@override@JsonKey() final  String listingType;
// For Sale, For Rent, For Charter
@override@JsonKey() final  bool isFeatured;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Listing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListingCopyWith<_Listing> get copyWith => __$ListingCopyWithImpl<_Listing>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Listing&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.itemType, itemType) || other.itemType == itemType)&&(identical(other.price, price) || other.price == price)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.category, category) || other.category == category)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.engineModel, engineModel) || other.engineModel == engineModel)&&(identical(other.bodyModel, bodyModel) || other.bodyModel == bodyModel)&&(identical(other.engineType, engineType) || other.engineType == engineType)&&(identical(other.enginePower, enginePower) || other.enginePower == enginePower)&&(identical(other.engineHours, engineHours) || other.engineHours == engineHours)&&(identical(other.bodyLength, bodyLength) || other.bodyLength == bodyLength)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.sellerName, sellerName) || other.sellerName == sellerName)&&(identical(other.listingType, listingType) || other.listingType == listingType)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,itemType,price,condition,category,sellerId,engineModel,bodyModel,engineType,enginePower,engineHours,bodyLength,description,address,const DeepCollectionEquality().hash(_imageUrls),sellerName,listingType,isFeatured,createdAt,updatedAt]);

@override
String toString() {
  return 'Listing(id: $id, name: $name, itemType: $itemType, price: $price, condition: $condition, category: $category, sellerId: $sellerId, engineModel: $engineModel, bodyModel: $bodyModel, engineType: $engineType, enginePower: $enginePower, engineHours: $engineHours, bodyLength: $bodyLength, description: $description, address: $address, imageUrls: $imageUrls, sellerName: $sellerName, listingType: $listingType, isFeatured: $isFeatured, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ListingCopyWith<$Res> implements $ListingCopyWith<$Res> {
  factory _$ListingCopyWith(_Listing value, $Res Function(_Listing) _then) = __$ListingCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String itemType, double price, String condition, String category, String sellerId, String? engineModel, String? bodyModel, String? engineType, String? enginePower, String? engineHours, String? bodyLength, String? description, String? address, List<String> imageUrls, String? sellerName, String listingType, bool isFeatured, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$ListingCopyWithImpl<$Res>
    implements _$ListingCopyWith<$Res> {
  __$ListingCopyWithImpl(this._self, this._then);

  final _Listing _self;
  final $Res Function(_Listing) _then;

/// Create a copy of Listing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? itemType = null,Object? price = null,Object? condition = null,Object? category = null,Object? sellerId = null,Object? engineModel = freezed,Object? bodyModel = freezed,Object? engineType = freezed,Object? enginePower = freezed,Object? engineHours = freezed,Object? bodyLength = freezed,Object? description = freezed,Object? address = freezed,Object? imageUrls = null,Object? sellerName = freezed,Object? listingType = null,Object? isFeatured = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Listing(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,itemType: null == itemType ? _self.itemType : itemType // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,sellerId: null == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String,engineModel: freezed == engineModel ? _self.engineModel : engineModel // ignore: cast_nullable_to_non_nullable
as String?,bodyModel: freezed == bodyModel ? _self.bodyModel : bodyModel // ignore: cast_nullable_to_non_nullable
as String?,engineType: freezed == engineType ? _self.engineType : engineType // ignore: cast_nullable_to_non_nullable
as String?,enginePower: freezed == enginePower ? _self.enginePower : enginePower // ignore: cast_nullable_to_non_nullable
as String?,engineHours: freezed == engineHours ? _self.engineHours : engineHours // ignore: cast_nullable_to_non_nullable
as String?,bodyLength: freezed == bodyLength ? _self.bodyLength : bodyLength // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,sellerName: freezed == sellerName ? _self.sellerName : sellerName // ignore: cast_nullable_to_non_nullable
as String?,listingType: null == listingType ? _self.listingType : listingType // ignore: cast_nullable_to_non_nullable
as String,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
