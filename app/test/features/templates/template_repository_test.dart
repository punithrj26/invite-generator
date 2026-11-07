import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:invite_generator/core/error/app_failure.dart';
import 'package:invite_generator/features/templates/data/template_repository_impl.dart';

Map<String, dynamic> _tpl(String id) => {
  'id': id,
  'key': 'k-$id',
  'version': 1,
  'name': 'Design $id',
  'eventTypes': ['birthday'],
  'tags': <String>[],
  'isPremium': false,
  'minRendererVersion': 1,
  'spec': {
    'canvas': {'width': 1080, 'height': 1920},
    'layers': <Object>[],
  },
};

/// Answers from [routes] (path → JSON body), or fails like a dropped connection when [offline].
class _FakeAdapter implements HttpClientAdapter {
  final routes = <String, Object>{};
  bool offline = false;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<List<int>>? _,
    Future<void>? _,
  ) async {
    requests.add(o);
    if (offline) {
      throw DioException.connectionError(requestOptions: o, reason: 'offline');
    }
    return ResponseBody.fromString(
      jsonEncode(routes[o.path]),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late Directory dir;
  late Box<String> box;
  late _FakeAdapter http;
  late TemplateRepositoryImpl repo;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('hive');
    Hive.init(dir.path);
    box = await Hive.openBox<String>('cache');
    http = _FakeAdapter()
      ..routes['/templates'] = {
        'items': [_tpl('a'), _tpl('b')],
        'nextCursor': null,
      };
    repo = TemplateRepositoryImpl(Dio()..httpClientAdapter = http, box);
  });

  tearDown(() async {
    await Hive.close();
    await dir.delete(recursive: true);
  });

  test('offline: list falls back to the last cached list', () async {
    expect((await repo.list()).map((t) => t.name), ['Design a', 'Design b']);
    http.offline = true;
    expect((await repo.list()).map((t) => t.name), ['Design a', 'Design b']);
  });

  test('offline with nothing cached: NetworkFailure', () async {
    http.offline = true;
    await expectLater(repo.list(), throwsA(isA<NetworkFailure>()));
  });

  test('get is cache-first: listed versions open without a request', () async {
    await repo.list();
    http.requests.clear();
    expect((await repo.get('b')).name, 'Design b');
    expect(http.requests, isEmpty);

    http.routes['/templates/c'] = _tpl('c');
    expect((await repo.get('c')).name, 'Design c');
    expect(http.requests.single.path, '/templates/c');
  });
}
