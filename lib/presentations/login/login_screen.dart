import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qiita_reader/presentations/login/login_view_model.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(loginViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('ログイン画面')),
      body: Center(
        child: ElevatedButton(
          onPressed: viewModel.startLogin,
          child: const Text('ログイン'),
        ),
      ),
    );
  }
}
