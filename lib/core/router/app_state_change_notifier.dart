import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qiita_reader/applications/auth_service/provider.dart';
import 'package:qiita_reader/core/router/route.dart';

final appStateChangeNotifierProvider =
    ChangeNotifierProvider<AppStateChangeNotifier>(AppStateChangeNotifier.new);

/// アプリの状態に伴うルート変更を管理するChangeNotifier
///
/// このNotifierのnotifyListenersが呼ばれると、GoRouterがrefreshされる。
class AppStateChangeNotifier extends ChangeNotifier {
  AppStateChangeNotifier(this.ref) {
    final isLoggedInSubscription = ref.listen(isLoggedInProvider, (_, __) {
      Future.microtask(notifyListeners);
    });
    ref.onDispose(isLoggedInSubscription.close);
  }

  final ChangeNotifierProviderRef<AppStateChangeNotifier> ref;

  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final isLoggedIn = await ref.read(isLoggedInProvider.future);

    switch (isLoggedIn) {
      case true:
        return _authGuard(state);
      case false:
        return _noAuthGuard(state);
    }
  }

  /// ログイン済みの場合のリダイレクトルール
  Future<String?> _authGuard(
    GoRouterState state,
  ) async {
    if (state.fullPath == const LoginRoute().location) {
      return const ListRoute().location;
    }

    return null;
  }

  /// 未ログインの場合のリダイレクトルール
  Future<String?> _noAuthGuard(
    GoRouterState state,
  ) async {
    if (state.fullPath != const LoginRoute().location) {
      return const LoginRoute().location;
    }
    return null;
  }
}
