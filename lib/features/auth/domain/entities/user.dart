import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String fullName,
    String? phoneNumber,
    String? address,
    String? profileImageUrl,
    @Default(true) bool emailVerified,
    @Default([]) List<String> wishlistItemIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}