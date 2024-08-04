import 'package:qiita_reader/applications/auth_service/provider.dart';
import 'package:qiita_reader/data/local_sources/shared_preference.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
Future<void> appStartup(AppStartupRef ref) async {
  // アプリ起動前に初期化したい処理を書く

  // sharedPreferencesを初期化
  await ref.read(sharedPreferencesProvider.future);

  // authServiceの初期化
  await ref.read(authServiceProvider).init();
}
