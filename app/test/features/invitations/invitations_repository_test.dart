import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invite_generator/core/error/app_failure.dart';
import 'package:invite_generator/features/invitations/data/invitations_repository_impl.dart';
import 'package:invite_generator/features/invitations/domain/invitation.dart';

final _json = {
  'id': 'i1',
  'status': 'draft',
  'eventData': {'type': 'birthday', 'personName': 'Aarav', 'age': 5},
  'details': {
    'eventName': 'Party',
    'hostName': 'Riya',
    'venue': {'name': 'Home'},
    'date': '2026-12-05',
    'time': '16:30',
    'timezone': 'Asia/Kolkata',
    'rsvp': {'enabled': false},
  },
  'templateId': null,
  'media': <String, dynamic>{},
  'version': 1,
  'updatedAt': '2026-11-06T10:00:00.000Z',
};

/// Records request bodies; answers [status] with [body].
class _Adapter implements HttpClientAdapter {
  final bodies = <Map<String, dynamic>>[];
  int status = 200;
  Object body = _json;

  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<List<int>>? _,
    Future<void>? _,
  ) async {
    if (o.data != null) {
      bodies.add(jsonDecode(jsonEncode(o.data)) as Map<String, dynamic>);
    }
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _Adapter http;
  late InvitationsRepositoryImpl repo;

  setUp(() {
    http = _Adapter();
    repo = InvitationsRepositoryImpl(Dio()..httpClientAdapter = http);
  });

  // Regression: Freezed omitted `type` for the single-variant union and the API rejected every app request.
  test(
    'create and update send eventData.type, nested details as JSON, and the version',
    () async {
      final created = await repo.create(
        eventData: const BirthdayData(personName: 'Aarav', age: 5),
        details: Invitation.fromJson(_json).details,
      );
      await repo.update(created);
      expect(http.bodies[0]['eventData'], {
        'type': 'birthday',
        'personName': 'Aarav',
        'age': 5,
      });
      expect(
        (http.bodies[0]['details'] as Map)['venue'],
        containsPair('name', 'Home'),
      );
      expect(http.bodies[1], containsPair('version', 1));
      expect((http.bodies[1]['eventData'] as Map)['type'], 'birthday');
    },
  );

  test('a 409 becomes ConflictFailure', () async {
    http
      ..status = 409
      ..body = {
        'error': {'code': 'CONFLICT', 'message': 'Updated on another device.'},
      };
    await expectLater(
      repo.update(Invitation.fromJson(_json)),
      throwsA(isA<ConflictFailure>()),
    );
  });
}
