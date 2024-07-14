import 'package:qiita_reader/data/repositories/key_value_repository/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

/// `KeyValueRepositoryBase` のインスタンスを生成
@Riverpod(keepAlive: true)
KeyValueRepositoryBase keyValueRepository(KeyValueRepositoryRef ref) {
  return KeyValueRepository(ref);
}

@riverpod
Stream<bool?> isFirstLaunch(IsFirstLaunchRef ref) async* {
  // リポジトリのプロバイダーからリポジトリオブジェクトを取得
  final repository = ref.read(keyValueRepositoryProvider);

  // 最初の値を取得し、yieldを使用してStreamに出力
  yield await repository.getIsFirstLaunch();

  // リポジトリの値変更通知を購読し、キーの変更のみにフィルターをかける
  await for (final _ in repository.onValueChange
      .where((key) => key == KeyValueRepository.isFirstLaunchKey)) {
    // 設定が変更されたとき、新しい値を取得し、yieldでStreamに出力
    yield await repository.getIsFirstLaunch();
  }
}
