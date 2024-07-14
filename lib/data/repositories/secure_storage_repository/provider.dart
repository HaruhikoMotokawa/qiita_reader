import 'package:qiita_reader/data/repositories/secure_storage_repository/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
SecureStorageRepositoryBase secureStorageRepository(
  SecureStorageRepositoryRef ref,
) {
  return SecureStorageRepository(ref);
}
