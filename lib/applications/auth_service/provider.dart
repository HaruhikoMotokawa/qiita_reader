import 'package:qiita_reader/applications/auth_service/service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
AuthServiceBase authService(AuthServiceRef ref) {
  return AuthService(ref);
}

@Riverpod(keepAlive: true)
Stream<bool> isLoggedIn(IsLoggedInRef ref) {
  return ref.read(authServiceProvider).isLoggedInStream;
}
