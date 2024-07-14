import 'package:go_router/go_router.dart';
import 'package:qiita_reader/core/router/app_state_change_notifier.dart';
import 'package:qiita_reader/core/router/route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    navigatorKey: rootNavigationKey,
    initialLocation: const LoginRoute().location,
    routes: $appRoutes,
    // ignore: avoid_manual_providers_as_generated_provider_dependency
    refreshListenable: ref.read(appStateChangeNotifierProvider),
    // ignore: avoid_manual_providers_as_generated_provider_dependency
    redirect: ref.read(appStateChangeNotifierProvider).redirect,
  );
}
