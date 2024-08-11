import 'package:qiita_reader/data/repositories/key_value_repository/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

/// `KeyValueRepositoryBase` のインスタンスを生成
@Riverpod(keepAlive: true)
KeyValueRepositoryBase keyValueRepository(KeyValueRepositoryRef ref) {
  return KeyValueRepository(ref);
}
