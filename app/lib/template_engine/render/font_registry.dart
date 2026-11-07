import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/template_spec.dart';

typedef FontFetcher = Future<ByteData> Function(String url);

/// Plain Dio: font URLs are public CDN files, so no auth interceptor (and no token leaks to the CDN).
Future<ByteData> _fetchOverHttp(String url) async {
  final res = await Dio().get<List<int>>(
    url,
    options: Options(responseType: ResponseType.bytes),
  );
  return ByteData.sublistView(Uint8List.fromList(res.data!));
}

final fontRegistryProvider = Provider<FontRegistry>(
  (ref) => FontRegistry(_fetchOverHttp),
);

/// Loads template fonts at runtime (docs/03 §5.2). Families are namespaced per template so a template's
/// "Poppins" never collides with another template's or the app's.
class FontRegistry {
  FontRegistry(this._fetch);

  final FontFetcher _fetch;
  final _loads = <String, Future<void>>{};

  static String familyFor(String scope, String family) =>
      'tpl_${scope}_$family';

  Future<void> ensureLoaded(String scope, List<FontSpec> fonts) {
    final byFamily = <String, List<FontSpec>>{};
    for (final f in fonts) {
      byFamily.putIfAbsent(f.family, () => []).add(f);
    }
    return Future.wait(
      byFamily.entries.map((e) {
        final name = familyFor(scope, e.key);
        return _loads.putIfAbsent(name, () {
          final loader = FontLoader(name);
          for (final f in e.value) {
            loader.addFont(_fetch(f.url));
          }
          // A failed load must not be cached, or the family stays broken until restart.
          return loader.load().catchError((Object e) {
            _loads.remove(name);
            throw e;
          });
        });
      }),
    );
  }
}
