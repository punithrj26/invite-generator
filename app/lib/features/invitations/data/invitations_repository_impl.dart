import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/network/failure_mapper.dart';
import '../domain/invitation.dart';
import '../domain/invitations_repository.dart';

final invitationsRepositoryProvider = Provider<InvitationsRepository>(
  (ref) => InvitationsRepositoryImpl(ref.watch(dioProvider)),
);

class InvitationsRepositoryImpl implements InvitationsRepository {
  InvitationsRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<InvitationsPage> list({String? cursor, int limit = 20}) =>
      guard(() async {
        final res = await _dio.get<Map<String, dynamic>>(
          '/invitations',
          queryParameters: {'limit': limit, 'cursor': ?cursor},
        );
        return (
          items: [
            for (final i in res.data!['items'] as List<dynamic>)
              InvitationSummary.fromJson(i as Map<String, dynamic>),
          ],
          nextCursor: res.data!['nextCursor'] as String?,
        );
      });

  @override
  Future<Invitation> get(String id) => guard(() async {
    final res = await _dio.get<Map<String, dynamic>>('/invitations/$id');
    return Invitation.fromJson(res.data!);
  });

  @override
  Future<Invitation> create({
    required EventData eventData,
    required EventDetails details,
  }) => guard(() async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/invitations',
      data: {'eventData': eventData.toApiJson(), 'details': details.toJson()},
    );
    return Invitation.fromJson(res.data!);
  });

  @override
  Future<Invitation> update(Invitation i) => guard(() async {
    final res = await _dio.put<Map<String, dynamic>>(
      '/invitations/${i.id}',
      data: {
        'version': i.version,
        'eventData': i.eventData.toApiJson(),
        'details': i.details.toJson(),
        'templateId': i.templateId,
        'media': {'photoUrl': i.media.photoUrl},
      },
    );
    return Invitation.fromJson(res.data!);
  });

  @override
  Future<void> delete(String id) =>
      guard(() => _dio.delete<void>('/invitations/$id'));
}
