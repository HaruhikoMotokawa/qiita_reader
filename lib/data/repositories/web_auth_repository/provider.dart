import 'package:qiita_reader/data/repositories/web_auth_repository/ripository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
WebAuthRepositoryBase webAuthRepository(WebAuthRepositoryRef ref) {
  return WebAuthRepository(ref);
}
