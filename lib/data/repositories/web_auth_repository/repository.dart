import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ウェブ経由で認証を行う
// ignore: one_member_abstracts
abstract interface class WebAuthRepositoryBase {
  Future<String?> fetchAuthorizationCode({
    required String url,
    required String callbackUrlScheme,
  });
}

class WebAuthRepository implements WebAuthRepositoryBase {
  WebAuthRepository(this.ref);

  final ProviderRef<dynamic> ref;

  @override
  Future<String?> fetchAuthorizationCode({
    required String url,
    required String callbackUrlScheme,
  }) async {
    try {
      // FlutterWebAuth2を使って認証を行う
      final result = await FlutterWebAuth2.authenticate(
        // 認証を行う問い合わせ先を指定
        url: url,
        // あらかじめ登録した認証が終わったら認可コードを返却する先（このアプリ）の名称を指定
        callbackUrlScheme: 'qiita-reader',
        // ここをtrueにしておくと、iOSだと処理を開始した時の内部ブラウザに移動する時の
        // 確認のダイアログの表示が省略される
        options: const FlutterWebAuth2Options(preferEphemeral: true),
      );
      // 認可コードを'code'というパラメータで入っているので、それを使って取り出す
      final code = Uri.parse(result).queryParameters['code'];
      // 取り出したコードを返却する
      return code;
    } catch (e) {
      rethrow;
    }
  }
}
