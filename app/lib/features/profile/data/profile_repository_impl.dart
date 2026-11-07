import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/network/failure_mapper.dart';
import '../../../core/storage/token_store.dart';
import '../../auth/domain/user.dart';
import '../domain/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(
    ref.watch(dioProvider),
    ref.watch(tokenStoreProvider),
  ),
);

/// Bodies are three small flat maps, so they're built inline rather than as DTO classes.
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._dio, this._tokens);

  final Dio _dio;
  final TokenStore _tokens;

  @override
  Future<User> update({required String name, String? phone}) => guard(() async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/users/me',
      data: {
        'name': name,
        'phone': (phone == null || phone.isEmpty) ? null : phone,
      },
    );
    return User.fromJson(res.data!);
  });

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => guard(
    () => _dio.post<void>(
      '/users/me/password',
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    ),
  );

  @override
  Future<void> deleteAccount({required String password}) => guard(() async {
    await _dio.delete<void>('/users/me', data: {'password': password});
    await _tokens.clear();
  });
}
