import 'dart:async';

import 'package:dio/dio.dart';
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
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract interface class AuthServiceBase {
  /// 初期化
  Future<void> init();

  /// ログイン処理
  Future<void> login();

  /// ログアウトの処理
  Future<void> logout();

  /// ログイン状態の変更を通知するストリーム
  Stream<bool> get isLoggedInStream;
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
  final StreamController<bool> _authStateChanges = StreamController<bool>();

  @override
  Stream<bool> get isLoggedInStream => _authStateChanges.stream;

  @override
  Future<void> init() async {
    // 一回でもログインしたことがあるかを確認
    final isFirstLogin = await _keyValueStore.getIsFirstLogin();
    if (isFirstLogin == null || isFirstLogin) {
      // アプリを再ダウンロードした場合を加味して念のためアクセストークンをnullで登録
      await _secureStorage.setAccessToken(null);
    }
    final accessToken = await _secureStorage.getAccessToken();
    _authStateChanges.sink.add(accessToken != null);
  }

  @override
  Future<void> login() async {
    try {
      // webAuthで認可コードを取得
      final code = await _webAuth.fetchAuthorizationCode();

      if (code == null) {
        throw Exception('認可コードがnullです');
      }

      // 認可コードでアクセストークンを取得する
      final accessToken = await _fetchAccessToken(code);

      if (accessToken == null) {
        throw Exception('アクセストークンががnullです');
      }
      // アクセストークンをセキュアストレージに保存する
      await _secureStorage.setAccessToken(accessToken);

      final isFirstLogin = await _keyValueStore.getIsFirstLogin();
      if (isFirstLogin == null || isFirstLogin == true) {
        // 今回が初めてのログインだった場合はフラグをfalseで保存する
        await _keyValueStore.setIsFirstLogin(value: false);
      }
      _authStateChanges.sink.add(true);
    } catch (e, s) {
      logger.e('エラーです', error: e, stackTrace: s);
    }
  }

  /// 認可コードを使ってアクセストークンを取得する
  Future<String?> _fetchAccessToken(String code) async {
    // もらった認可コードでアクセストークンを取得する
    // https://qiita.com/api/v2/docs#%E3%82%A2%E3%82%AF%E3%82%BB%E3%82%B9%E3%83%88%E3%83%BC%E3%82%AF%E3%83%B3-1
    final data = {
      'client_id': Env.clientId,
      'client_secret': Env.clientSecret,
      'code': code,
    };
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        Constants.tokenEndPoint,
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final accessToken = response.data?['token'].toString();
        return accessToken;
      } else {
        logger.e('ステータスコード：${response.statusCode}');
        return null;
      }
    } catch (e, s) {
      logger.e('不明なエラー', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    // 保存されたアクセストークンを取得
    final accessToken = await _secureStorage.getAccessToken();
    if (accessToken == null) return;

    // サーバーにアクセストークンの破棄を要求
    final path = '${Constants.tokenEndPoint}/$accessToken';
    final response = await _httpClient.delete<Response<dynamic>>(path);
    // サーバーで削除が成功したら実行
    if (response.statusCode == 204) {
      // セキュアストレージのアクセストークンを削除する
      await _secureStorage.setAccessToken(null);
      _authStateChanges.sink.add(false);
    } else {
      logger.e('ログアウトに失敗しました');
    }
  }
}
