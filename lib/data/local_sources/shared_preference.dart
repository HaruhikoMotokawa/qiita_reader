import 'package:qiita_reader/core/log/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preference.g.dart';

/// SharedPreferencesのインスタンスを非同期に生成
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  try {
    // 全ての SharedPreferences のキーに接頭辞を設定
    SharedPreferences.setPrefix('qiita_reader');
  } catch (error, stackTrace) {
    logger.d(
      'SharedPreferences.setPrefixエラー',
      error: error,
      stackTrace: stackTrace,
    );
  }

  return SharedPreferences.getInstance();
}
