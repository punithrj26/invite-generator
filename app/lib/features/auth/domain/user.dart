import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// The signed-in user (API: `GET /v1/users/me`, docs/02 §2.4).
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    String? phone,
    String? avatarUrl,
    @Default(<String>['user']) List<String> roles,
    @Default('free') String plan,
    required DateTime createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
