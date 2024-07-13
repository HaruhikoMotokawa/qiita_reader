import 'package:go_router/go_router.dart';
import 'package:qiita_reader/core/router/route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    navigatorKey: rootNavigationKey,
    initialLocation: const LoginRoute().location,
    routes: $appRoutes,
  );
}
