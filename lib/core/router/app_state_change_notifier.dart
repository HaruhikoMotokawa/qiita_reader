import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qiita_reader/applications/auth_service/provider.dart';
import 'package:qiita_reader/core/router/route.dart';

/// アプリケーションの状態変化に基づいてルートを管理するためのプロバイダ
final appStateChangeNotifierProvider =
    ChangeNotifierProvider<AppStateChangeNotifier>(AppStateChangeNotifier.new);

/// アプリの状態に伴うルート変更を管理する`ChangeNotifier`
///
/// `notifyListeners`が呼び出されると、`GoRouter`が`refresh`され、
/// 必要に応じてリダイレクト処理が行われます。
class AppStateChangeNotifier extends ChangeNotifier {
  AppStateChangeNotifier(this.ref) {
    // `isLoggedInProvider`の変更を監視し、変更があれば`notifyListeners`を非同期に呼び出す
    final isLoggedInSubscription = ref.listen(isLoggedInProvider, (_, __) {
      Future.microtask(notifyListeners);
    });

    // このNotifierが破棄されるときに`isLoggedInSubscription`もクリーンアップされるようにする
    ref.onDispose(isLoggedInSubscription.close);
  }

  // このクラスが依存するプロバイダを操作するためのレフ
  final ChangeNotifierProviderRef<AppStateChangeNotifier> ref;

  /// ルート遷移時に呼び出され、リダイレクト先のパスを返す非同期メソッド
  ///
  /// ログイン状態に基づいて、適切なリダイレクトルールを適用します。
  /// - `return`: リダイレクト先のパス。リダイレクトが不要な場合は`null`を返します。
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final isLoggedIn = await ref.read(isLoggedInProvider.future);

    // ログイン状態に応じて適切なガードを適用
    switch (isLoggedIn) {
      case true:
        return _authGuard(state);
      case false:
        return _noAuthGuard(state);
    }
  }

  /// ログイン済みユーザー向けのリダイレクトルール
  ///
  /// ログイン済みの場合、ログイン画面にアクセスしようとするとリスト画面にリダイレクトします。
  /// - `state`: 現在のルートの状態を保持する`GoRouterState`
  /// - `return`: リダイレクト先のパス。リダイレクトが不要な場合は`null`を返します。
  Future<String?> _authGuard(
    GoRouterState state,
  ) async {
    // ログイン画面にアクセスしようとした場合、リスト画面にリダイレクト
    if (state.fullPath == const LoginRoute().location) {
      return const ListRoute().location;
    }

    return null; // リダイレクトが不要な場合
  }

  /// 未ログインユーザー向けのリダイレクトルール
  ///
  /// 未ログインの場合、ログイン画面以外のアクセスを試みるとログイン画面にリダイレクトします。
  /// - `return`: リダイレクト先のパス。リダイレクトが不要な場合は`null`を返します。
  Future<String?> _noAuthGuard(
    GoRouterState state,
  ) async {
    // ログイン画面以外にアクセスしようとした場合、ログイン画面にリダイレクト
    if (state.fullPath != const LoginRoute().location) {
      return const LoginRoute().location;
    }
    return null; // リダイレクトが不要な場合
  }
}
