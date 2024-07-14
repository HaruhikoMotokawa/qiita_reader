// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$keyValueRepositoryHash() =>
    r'aa88153e6e212e188875b8cf9bec98f2ace0a655';

/// `KeyValueRepositoryBase` のインスタンスを生成
///
/// Copied from [keyValueRepository].
@ProviderFor(keyValueRepository)
final keyValueRepositoryProvider = Provider<KeyValueRepositoryBase>.internal(
  keyValueRepository,
  name: r'keyValueRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$keyValueRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef KeyValueRepositoryRef = ProviderRef<KeyValueRepositoryBase>;
String _$isFirstLaunchHash() => r'b1ee25d19d2e025364077f056c869fd4fbcb6b37';

/// See also [isFirstLaunch].
@ProviderFor(isFirstLaunch)
final isFirstLaunchProvider = AutoDisposeStreamProvider<bool?>.internal(
  isFirstLaunch,
  name: r'isFirstLaunchProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isFirstLaunchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsFirstLaunchRef = AutoDisposeStreamProviderRef<bool?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
