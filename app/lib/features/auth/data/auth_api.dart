import 'package:dio/dio.dart';

import '../domain/user.dart';
import 'dto.dart';

/// Thin typed client for `/v1/auth/*` and `GET /v1/users/me`. JSON ↔ models only.
class AuthApi {
  AuthApi(this._dio);
  final Dio _dio;

  Future<AuthResponse> register(RegisterRequest body) async =>
      AuthResponse.fromJson(
        (await _dio.post<Map<String, dynamic>>(
          '/auth/register',
          data: body.toJson(),
        )).data!,
      );

  Future<AuthResponse> login(LoginRequest body) async => AuthResponse.fromJson(
    (await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: body.toJson(),
    )).data!,
  );

  /// [refreshToken] is null on web (the cookie identifies the session).
  Future<void> logout(String? refreshToken) =>
      _dio.post<void>('/auth/logout', data: {'refreshToken': ?refreshToken});

  Future<User> me() async =>
      User.fromJson((await _dio.get<Map<String, dynamic>>('/users/me')).data!);
}
