import 'dart:async';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qiita_reader/core/constants/constants.dart';
import 'package:qiita_reader/core/env.dart';
import 'package:qiita_reader/core/log/logger.dart';
import 'package:qiita_reader/data/remote_sources/http.dart';
import 'package:qiita_reader/data/repositories/key_value_repository/provider.dart';
import 'package:qiita_reader/data/repositories/key_value_repository/repository.dart';
import 'package:qiita_reader/data/repositories/secure_storage_repository/provider.dart';
import 'package:qiita_reader/data/repositories/secure_storage_repository/repository.dart';
import 'package:qiita_reader/data/repositories/web_auth_repository/provider.dart';
import 'package:qiita_reader/data/repositories/web_auth_repository/repository.dart';

abstract interface class AuthServiceBase {
  Future<void> login();
  Future<void> logout();
}

class AuthService implements AuthServiceBase {
  AuthService(this.ref);

  final ProviderRef<dynamic> ref;

  WebAuthRepositoryBase get _webAuth => ref.read(webAuthRepositoryProvider);
  KeyValueRepositoryBase get _keyValueStore =>
      ref.read(keyValueRepositoryProvider);
  SecureStorageRepositoryBase get _secureStorage =>
      ref.read(secureStorageRepositoryProvider);
  Dio get _httpClient => ref.read(httpProvider);

  @override
  Future<void> login() async {
    // await _initToken();
    final isFirstLogin = await _keyValueStore.getIsFirstLogin();
    if (isFirstLogin != null && isFirstLogin) {
      await _secureStorage.setAccessToken(null);
    }
    // webAuthで認可コードを撮りにいく
    final code = await _webAuth.fetchAuthorizationCode(
      url: Constants.authUrl,
      callbackUrlScheme: 'qiita-reader',
    );
    // もらった認可コードでアクセストークンを取得する
    final queryParameters = {
      'client_id': Env.clientId,
      'client_secret': Env.clientSecret,
      'code': code,
    };
    final response = await _httpClient.post<Map<String, dynamic>>(
      Constants.tokenEndPoint,
      queryParameters: queryParameters,
    );
    final data = response.data;
    if (data != null) {
      final accessToken = data['token'];
      // アクセストークンをセキュアに保存する
      if (accessToken is String) {
        await _secureStorage.setAccessToken(accessToken);
        // final result = await _keyValueStore.getIsFirstLogin();
        if (isFirstLogin == null || isFirstLogin == true) {
          await _keyValueStore.setIsFirstLogin(value: false);
        }
      }
    }
  }

  @override
  Future<void> logout() async {
    final accessToken = await _secureStorage.getAccessToken();
    if (accessToken == null) return;
    final path = '${Constants.tokenEndPoint}/$accessToken';
    final response = await _httpClient.delete<Response<dynamic>>(path);
    if (response.statusCode == 204) {
      // セキュアストレージのアクセストークンを削除する
      await _secureStorage.setAccessToken(null);
    } else {
      logger.e('ログアウトに失敗しました');
    }
  }
}
