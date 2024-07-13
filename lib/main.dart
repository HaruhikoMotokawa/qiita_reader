import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qiita_reader/core/app.dart';
import 'package:qiita_reader/presentations/app_start_up/app_start_up_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: AppStartupScreen(onLoaded: (_) => const App()),
    ),
  );
}
