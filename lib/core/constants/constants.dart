import 'package:qiita_reader/core/env.dart';

/// アプリ内で仕様する定数を管理する
abstract final class Constants {
  static const host = 'qiita.com';
  static const authEndPoint = '/api/v2/oauth/authorize';
  static const scope = 'read_qiita';
  static const state = 'bb17785d811bb1913ef54b0a7657de780defaa2d';

  static String get qiitaBaseUrl => Uri.https(host).toString();

  static String get authUrl {
    return Uri.https(host, authEndPoint, {
      'client_id': Env.clientId,
      'scope': scope,
      'state': state,
    }).toString();
  }

  static const tokenEndPoint = '/api/v2/access_tokens';
}
