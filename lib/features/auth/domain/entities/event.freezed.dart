// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Event {

 String get id; String get name; String get eventType;// Party, Birthday, Gala
 double get bookingPrice; String get organizerId; String? get category;// Yacht Tour, Boat Cruise
 String? get duration;// e.g., "2-3 hours"
 String? get guide;// e.g., "Live tour guide"
 String? get location; String? get departureLocation;// Lousail, Pearl, Box park
 String? get description; List<String> get imageUrls; bool get includesFoodAndDrinks; String get accessType;// Public, Private
 String? get organizerName; DateTime? get eventDate; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCopyWith<Event> get copyWith => _$EventCopyWithImpl<Event>(this as Event, _$identity);

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Event&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.bookingPrice, bookingPrice) || other.bookingPrice == bookingPrice)&&(identical(other.organizerId, organizerId) || other.organizerId == organizerId)&&(identical(other.category, category) || other.category == category)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.guide, guide) || other.guide == guide)&&(identical(other.location, location) || other.location == location)&&(identical(other.departureLocation, departureLocation) || other.departureLocation == departureLocation)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.includesFoodAndDrinks, includesFoodAndDrinks) || other.includesFoodAndDrinks == includesFoodAndDrinks)&&(identical(other.accessType, accessType) || other.accessType == accessType)&&(identical(other.organizerName, organizerName) || other.organizerName == organizerName)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,eventType,bookingPrice,organizerId,category,duration,guide,location,departureLocation,description,const DeepCollectionEquality().hash(imageUrls),includesFoodAndDrinks,accessType,organizerName,eventDate,createdAt,updatedAt);

@override
String toString() {
  return 'Event(id: $id, name: $name, eventType: $eventType, bookingPrice: $bookingPrice, organizerId: $organizerId, category: $category, duration: $duration, guide: $guide, location: $location, departureLocation: $departureLocation, description: $description, imageUrls: $imageUrls, includesFoodAndDrinks: $includesFoodAndDrinks, accessType: $accessType, organizerName: $organizerName, eventDate: $eventDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $EventCopyWith<$Res>  {
  factory $EventCopyWith(Event value, $Res Function(Event) _then) = _$EventCopyWithImpl;
@useResult
$Res call({
 String id, String name, String eventType, double bookingPrice, String organizerId, String? category, String? duration, String? guide, String? location, String? departureLocation, String? description, List<String> imageUrls, bool includesFoodAndDrinks, String accessType, String? organizerName, DateTime? eventDate, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$EventCopyWithImpl<$Res>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._self, this._then);

  final Event _self;
  final $Res Function(Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? eventType = null,Object? bookingPrice = null,Object? organizerId = null,Object? category = freezed,Object? duration = freezed,Object? guide = freezed,Object? location = freezed,Object? departureLocation = freezed,Object? description = freezed,Object? imageUrls = null,Object? includesFoodAndDrinks = null,Object? accessType = null,Object? organizerName = freezed,Object? eventDate = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,bookingPrice: null == bookingPrice ? _self.bookingPrice : bookingPrice // ignore: cast_nullable_to_non_nullable
as double,organizerId: null == organizerId ? _self.organizerId : organizerId // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String?,guide: freezed == guide ? _self.guide : guide // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,departureLocation: freezed == departureLocation ? _self.departureLocation : departureLocation // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,includesFoodAndDrinks: null == includesFoodAndDrinks ? _self.includesFoodAndDrinks : includesFoodAndDrinks // ignore: cast_nullable_to_non_nullable
as bool,accessType: null == accessType ? _self.accessType : accessType // ignore: cast_nullable_to_non_nullable
as String,organizerName: freezed == organizerName ? _self.organizerName : organizerName // ignore: cast_nullable_to_non_nullable
as String?,eventDate: freezed == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Event].
extension EventPatterns on Event {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Event value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Event value)  $default,){
final _that = this;
switch (_that) {
case _Event():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Event value)?  $default,){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String eventType,  double bookingPrice,  String organizerId,  String? category,  String? duration,  String? guide,  String? location,  String? departureLocation,  String? description,  List<String> imageUrls,  bool includesFoodAndDrinks,  String accessType,  String? organizerName,  DateTime? eventDate,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.name,_that.eventType,_that.bookingPrice,_that.organizerId,_that.category,_that.duration,_that.guide,_that.location,_that.departureLocation,_that.description,_that.imageUrls,_that.includesFoodAndDrinks,_that.accessType,_that.organizerName,_that.eventDate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String eventType,  double bookingPrice,  String organizerId,  String? category,  String? duration,  String? guide,  String? location,  String? departureLocation,  String? description,  List<String> imageUrls,  bool includesFoodAndDrinks,  String accessType,  String? organizerName,  DateTime? eventDate,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Event():
return $default(_that.id,_that.name,_that.eventType,_that.bookingPrice,_that.organizerId,_that.category,_that.duration,_that.guide,_that.location,_that.departureLocation,_that.description,_that.imageUrls,_that.includesFoodAndDrinks,_that.accessType,_that.organizerName,_that.eventDate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String eventType,  double bookingPrice,  String organizerId,  String? category,  String? duration,  String? guide,  String? location,  String? departureLocation,  String? description,  List<String> imageUrls,  bool includesFoodAndDrinks,  String accessType,  String? organizerName,  DateTime? eventDate,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.name,_that.eventType,_that.bookingPrice,_that.organizerId,_that.category,_that.duration,_that.guide,_that.location,_that.departureLocation,_that.description,_that.imageUrls,_that.includesFoodAndDrinks,_that.accessType,_that.organizerName,_that.eventDate,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Event implements Event {
  const _Event({required this.id, required this.name, required this.eventType, required this.bookingPrice, required this.organizerId, this.category, this.duration, this.guide, this.location, this.departureLocation, this.description, final  List<String> imageUrls = const [], this.includesFoodAndDrinks = false, this.accessType = 'Public', this.organizerName, this.eventDate, this.createdAt, this.updatedAt}): _imageUrls = imageUrls;
  factory _Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

@override final  String id;
@override final  String name;
@override final  String eventType;
// Party, Birthday, Gala
@override final  double bookingPrice;
@override final  String organizerId;
@override final  String? category;
// Yacht Tour, Boat Cruise
@override final  String? duration;
// e.g., "2-3 hours"
@override final  String? guide;
// e.g., "Live tour guide"
@override final  String? location;
@override final  String? departureLocation;
// Lousail, Pearl, Box park
@override final  String? description;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override@JsonKey() final  bool includesFoodAndDrinks;
@override@JsonKey() final  String accessType;
// Public, Private
@override final  String? organizerName;
@override final  DateTime? eventDate;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventCopyWith<_Event> get copyWith => __$EventCopyWithImpl<_Event>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Event&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.bookingPrice, bookingPrice) || other.bookingPrice == bookingPrice)&&(identical(other.organizerId, organizerId) || other.organizerId == organizerId)&&(identical(other.category, category) || other.category == category)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.guide, guide) || other.guide == guide)&&(identical(other.location, location) || other.location == location)&&(identical(other.departureLocation, departureLocation) || other.departureLocation == departureLocation)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.includesFoodAndDrinks, includesFoodAndDrinks) || other.includesFoodAndDrinks == includesFoodAndDrinks)&&(identical(other.accessType, accessType) || other.accessType == accessType)&&(identical(other.organizerName, organizerName) || other.organizerName == organizerName)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,eventType,bookingPrice,organizerId,category,duration,guide,location,departureLocation,description,const DeepCollectionEquality().hash(_imageUrls),includesFoodAndDrinks,accessType,organizerName,eventDate,createdAt,updatedAt);

@override
String toString() {
  return 'Event(id: $id, name: $name, eventType: $eventType, bookingPrice: $bookingPrice, organizerId: $organizerId, category: $category, duration: $duration, guide: $guide, location: $location, departureLocation: $departureLocation, description: $description, imageUrls: $imageUrls, includesFoodAndDrinks: $includesFoodAndDrinks, accessType: $accessType, organizerName: $organizerName, eventDate: $eventDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$EventCopyWith(_Event value, $Res Function(_Event) _then) = __$EventCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String eventType, double bookingPrice, String organizerId, String? category, String? duration, String? guide, String? location, String? departureLocation, String? description, List<String> imageUrls, bool includesFoodAndDrinks, String accessType, String? organizerName, DateTime? eventDate, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$EventCopyWithImpl<$Res>
    implements _$EventCopyWith<$Res> {
  __$EventCopyWithImpl(this._self, this._then);

  final _Event _self;
  final $Res Function(_Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? eventType = null,Object? bookingPrice = null,Object? organizerId = null,Object? category = freezed,Object? duration = freezed,Object? guide = freezed,Object? location = freezed,Object? departureLocation = freezed,Object? description = freezed,Object? imageUrls = null,Object? includesFoodAndDrinks = null,Object? accessType = null,Object? organizerName = freezed,Object? eventDate = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Event(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,bookingPrice: null == bookingPrice ? _self.bookingPrice : bookingPrice // ignore: cast_nullable_to_non_nullable
as double,organizerId: null == organizerId ? _self.organizerId : organizerId // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String?,guide: freezed == guide ? _self.guide : guide // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,departureLocation: freezed == departureLocation ? _self.departureLocation : departureLocation // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,includesFoodAndDrinks: null == includesFoodAndDrinks ? _self.includesFoodAndDrinks : includesFoodAndDrinks // ignore: cast_nullable_to_non_nullable
as bool,accessType: null == accessType ? _self.accessType : accessType // ignore: cast_nullable_to_non_nullable
as String,organizerName: freezed == organizerName ? _self.organizerName : organizerName // ignore: cast_nullable_to_non_nullable
as String?,eventDate: freezed == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
