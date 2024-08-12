import 'dart:async';

import 'package:qiita_reader/data/local_sources/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract interface class SecureStorageRepositoryBase {
  Future<String?> getAccessToken();
  Future<void> setAccessToken(String? token);
}

class SecureStorageRepository implements SecureStorageRepositoryBase {
  SecureStorageRepository(this.ref);

  final ProviderRef<dynamic> ref;

  static const accessTokenKey = 'accessToken';

  @override
  Future<String?> getAccessToken() => _get<String>(accessTokenKey);

  @override
  Future<void> setAccessToken(String? token) => _set(accessTokenKey, token);

  Future<T?> _get<T>(String key) async {
    final secureStorage = ref.read(secureStorageProvider);
    final value = await secureStorage.read(key: key);
    switch (T) {
      case int:
        return int.tryParse(value ?? '') as T?;
      case double:
        return double.tryParse(value ?? '') as T?;
      case bool:
        return bool.tryParse(value ?? '') as T?;
      case String:
        return value as T?;
      case DateTime:
        return DateTime.tryParse(value ?? '') as T?;
      case _:
        throw UnsupportedError('対応していない型です。');
    }
  }

  Future<void> _set(String key, Object? value) async {
    final secureStorage = ref.read(secureStorageProvider);

    switch (value) {
      case final int v:
        await secureStorage.write(key: key, value: v.toString());
      case final double v:
        await secureStorage.write(key: key, value: v.toString());
      case final bool v:
        await secureStorage.write(key: key, value: v.toString());
      case final String v:
        await secureStorage.write(key: key, value: v);
      case final DateTime v:
        await secureStorage.write(key: key, value: v.toIso8601String());
      case null:
        await secureStorage.delete(key: key);
      default:
        throw UnsupportedError('対応していない型です。');
    }
  }
}
