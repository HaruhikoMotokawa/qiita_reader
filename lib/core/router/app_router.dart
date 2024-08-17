// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency

import 'package:go_router/go_router.dart';
import 'package:qiita_reader/core/router/app_state_change_notifier.dart';
import 'package:qiita_reader/core/router/route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    // アプリケーション全体のナビゲーションを管理するためのキーを設定
    navigatorKey: rootNavigationKey,
    // アプリ起動時に最初に表示する画面のルートを指定
    initialLocation: const LoginRoute().location,
    // 使用するルート一覧を指定（go_router_builderで自動生成されたルート）
    routes: $appRoutes,
    // ルートのリフレッシュを監視するためのリスナーを設定
    refreshListenable: ref.read(appStateChangeNotifierProvider),
    // 特定の条件に基づいてリダイレクトを行うロジックを指定
    redirect: ref.read(appStateChangeNotifierProvider).redirect,
  );
}
