import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qiita_reader/core/router/app_navigation_bar.dart';
import 'package:qiita_reader/presentations/list/list_screen.dart';
import 'package:qiita_reader/presentations/login/login_screen.dart';
import 'package:qiita_reader/presentations/settings/settings_screen.dart';

part 'route.g.dart';

final rootNavigationKey = GlobalKey<NavigatorState>();

@TypedShellRoute<AppShellRoute>(
  routes: [
    TypedStatefulShellRoute<NavigationShellRoute>(
      branches: [
        TypedStatefulShellBranch<ListBranch>(
          routes: [
            TypedGoRoute<ListRoute>(
              path: '/',
              name: 'list_screen',
            ),
          ],
        ),
        TypedStatefulShellBranch<SettingsBranch>(
          routes: [
            TypedGoRoute<SettingsRoute>(
              path: '/settings',
              name: 'settings_screen',
            ),
          ],
        ),
      ],
    ),
    TypedGoRoute<LoginRoute>(
      path: '/login',
      name: 'login_screen',
    ),
  ],
)

/// アプリの大元のルート
class AppShellRoute extends ShellRouteData {
  const AppShellRoute();

  static final $navigationKey = rootNavigationKey;

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    Widget navigator,
  ) {
    return Scaffold(
      body: navigator,
    );
  }
}

// Branchはタブのルートの入れ物

class ListBranch extends StatefulShellBranchData {
  const ListBranch();
}

class SettingsBranch extends StatefulShellBranchData {
  const SettingsBranch();
}

/// タブのナビゲーターを設定
class NavigationShellRoute extends StatefulShellRouteData {
  const NavigationShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppNavigationBar(
        navigationShell: navigationShell,
      ),
    );
  }
}

// それぞれの画面を設定

class ListRoute extends GoRouteData {
  const ListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ListScreen();
  }
}

class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsScreen();
  }
}

class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginScreen();
  }
}
