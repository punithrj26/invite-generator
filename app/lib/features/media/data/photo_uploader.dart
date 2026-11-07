import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/network/dio_provider.dart';
import '../../../core/network/failure_mapper.dart';

final photoUploaderProvider = Provider<PhotoUploader>(
  (ref) => PhotoUploader(ref.watch(dioProvider), Dio()),
);

const _types = {
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'png': 'image/png',
  'webp': 'image/webp',
};

/// docs/02 §2.7: ask the API for a presigned POST, then send the bytes straight to S3.
class PhotoUploader {
  /// [_storage] is a bare Dio: the bucket must never see the API's bearer token.
  PhotoUploader(this._api, this._storage);

  final Dio _api;
  final Dio _storage;

  /// Returns the public URL to store in `media.photoUrl`.
  Future<String> upload(XFile file) => guard(() async {
    final type =
        file.mimeType ?? _types[file.name.split('.').last.toLowerCase()];
    if (type == null || !_types.containsValue(type)) {
      throw const ValidationFailure('Choose a JPEG, PNG or WebP photo.');
    }
    final bytes = await file.readAsBytes();
    final res = await _api.post<Map<String, dynamic>>(
      '/media/upload-url',
      data: {'purpose': 'photo', 'contentType': type},
    );
    final up = res.data!;
    if (bytes.length > (up['maxBytes'] as int)) {
      throw const ValidationFailure(
        'That photo is over 10 MB. Choose a smaller one.',
      );
    }
    await _storage.post<void>(
      up['url'] as String,
      data: FormData.fromMap({
        ...(up['fields'] as Map<String, dynamic>),
        // S3 requires the file to be the last form field.
        'file': MultipartFile.fromBytes(
          bytes,
          filename: file.name,
          contentType: DioMediaType.parse(type),
        ),
      }),
    );
    return up['cdnUrl'] as String;
  });
}
