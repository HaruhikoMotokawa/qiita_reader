import 'package:flutter_appauth/flutter_appauth.dart';

/// アプリ内で仕様する定数を管理する
abstract final class Constants {
  static const host = 'qiita.com';
  static const authEndPoint = '/api/v2/oauth/authorize';
  static const tokenEndPoint = '/api/v2/access_tokens';
  static const scope = ['read_qiita'];
  static const redirectUrl = 'qiita-reader://oauth-callback';
  static String get qiitaBaseUrl => Uri.https(host).toString();

  static const serviceConfiguration = AuthorizationServiceConfiguration(
    authorizationEndpoint: 'https://$host$authEndPoint',
    tokenEndpoint: 'https://$host$tokenEndPoint',
  );
}
