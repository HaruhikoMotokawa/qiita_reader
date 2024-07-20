import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_auth.g.dart';

@Riverpod(keepAlive: true)
FlutterAppAuth appAuth(AppAuthRef ref) {
  return const FlutterAppAuth();
}
