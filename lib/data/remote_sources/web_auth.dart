import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'web_auth.g.dart';

// FlutterWebAuth2のスタティックメソッドをラップするクラスを定義
class WebAuth2Wrapper {
  const WebAuth2Wrapper();

  Future<String> authenticate({
    required String url,
    required String callbackUrlScheme,
    required FlutterWebAuth2Options options,
  }) async {
    return FlutterWebAuth2.authenticate(
      url: url,
      callbackUrlScheme: callbackUrlScheme,
      options: options,
    );
  }
}

/// FlutterWebAuth2のスタティックメソッドをラップするクラスを提供する
@Riverpod(keepAlive: true)
WebAuth2Wrapper webAuth(WebAuthRef ref) {
  return const WebAuth2Wrapper();
}
