import 'package:qiita_reader/applications/auth_service/service.dart';
import 'package:qiita_reader/data/repositories/secure_storage_repository/provider.dart';
import 'package:qiita_reader/data/repositories/secure_storage_repository/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
AuthServiceBase authService(AuthServiceRef ref) {
  return AuthService(ref);
}

@Riverpod(keepAlive: true)
Stream<bool> isLoggedIn(IsLoggedInRef ref) async* {
  final secureStorage = ref.read(secureStorageRepositoryProvider);
  final accessToken = await secureStorage.getAccessToken();
  var result = accessToken?.isNotEmpty ?? false;
  yield result;

  await for (final _ in secureStorage.onValueChange
      .where((key) => key == SecureStorageRepository.accessTokenKey)) {
    final updateAccessToken = await secureStorage.getAccessToken();
    result = updateAccessToken?.isNotEmpty ?? false;
    yield result;
  }
}
