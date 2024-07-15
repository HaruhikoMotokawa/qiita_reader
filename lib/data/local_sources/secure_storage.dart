import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

/// FlutterSecureStorageのインスタンスを生成
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      // Androidの場合は暗号化を有効にする
      encryptedSharedPreferences: true,
    ),
  );
  return secureStorage;
}
