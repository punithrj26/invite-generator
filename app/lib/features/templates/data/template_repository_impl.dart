import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/network/dio_provider.dart';
import '../../../core/network/failure_mapper.dart';
import '../../../core/storage/cache_box.dart';
import '../domain/invitation_template.dart';
import '../domain/template_repository.dart';

final templateRepositoryProvider = Provider<TemplateRepository>(
  (ref) => TemplateRepositoryImpl(
    ref.watch(dioProvider),
    ref.watch(cacheBoxProvider),
  ),
);

class TemplateRepositoryImpl implements TemplateRepository {
  TemplateRepositoryImpl(this._dio, this._cache);

  final Dio _dio;
  final Box<String> _cache;

  @override
  Future<List<InvitationTemplate>> list({String eventType = 'birthday'}) async {
    final key = 'templates:list:$eventType';
    try {
      // shortcut: first page only (limit 50, Phase 1 ships 3 templates); page with nextCursor when the catalogue grows.
      final items = await guard(() async {
        final res = await _dio.get<Map<String, dynamic>>(
          '/templates',
          queryParameters: {'eventType': eventType, 'limit': 50},
        );
        return res.data!['items'] as List<dynamic>;
      });
      await _cache.put(key, jsonEncode(items));
      for (final t in items.cast<Map<String, dynamic>>()) {
        await _cache.put('templates:${t['id']}', jsonEncode(t));
      }
      return _parseList(items);
    } on NetworkFailure {
      final cached = _cache.get(key);
      if (cached == null) rethrow;
      return _parseList(jsonDecode(cached) as List<dynamic>);
    }
  }

  @override
  Future<InvitationTemplate> get(String id) async {
    final cached = _cache.get('templates:$id');
    if (cached != null) {
      return InvitationTemplate.fromJson(
        jsonDecode(cached) as Map<String, dynamic>,
      );
    }
    return guard(() async {
      final res = await _dio.get<Map<String, dynamic>>('/templates/$id');
      await _cache.put('templates:$id', jsonEncode(res.data));
      return InvitationTemplate.fromJson(res.data!);
    });
  }

  static List<InvitationTemplate> _parseList(List<dynamic> items) => [
    for (final t in items.cast<Map<String, dynamic>>())
      InvitationTemplate.fromJson(t),
  ];
}
