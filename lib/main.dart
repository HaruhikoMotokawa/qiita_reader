import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qiita_reader/presentations/app.dart';
import 'package:qiita_reader/presentations/app_start_up/app_start_up_screen.dart';

void main() {
  runApp(
    ProviderScope(
      // 最初に初期化画面で必要な初期化をしたのちにAppを立ち上げる
      child: AppStartupScreen(onLoaded: (_) => const App()),
    ),
  );
}
