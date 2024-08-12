import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qiita_reader/core/constants/constants.dart';
import 'package:qiita_reader/core/env.dart';
import 'package:qiita_reader/core/log/logger.dart';
import 'package:qiita_reader/data/remote_sources/app_auth.dart';

/// ウェブ経由で認証を行う
// ignore: one_member_abstracts
abstract interface class WebAuthRepositoryBase {
  /// 認可コードを取得する
  Future<String?> fetchAuthorizationCode();
}

class WebAuthRepository implements WebAuthRepositoryBase {
  WebAuthRepository(this.ref);

  final ProviderRef<dynamic> ref;

  @override
  Future<String?> fetchAuthorizationCode() async {
    try {
      final webAuth = ref.read(appAuthProvider);

      // 認可コードを要求
      final result = await webAuth.authorize(
        AuthorizationRequest(
          Env.clientId,
          Constants.redirectUrl,
          serviceConfiguration: Constants.serviceConfiguration,
          scopes: Constants.scope,
        ),
      );

      if (result == null || result.authorizationCode == null) {
        logger.e('認可コードが取得できませんした', stackTrace: StackTrace.current);
        return null;
      }
      // 取り出したコードを返却する
      return result.authorizationCode;
    } catch (e, s) {
      logger.e('エラーが発生しました', error: e, stackTrace: s);
      return null;
    }
  }
}
