import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qiita_reader/applications/auth_service/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('設定'),
            const Gap(50),
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return ElevatedButton(
                  onPressed: ref.read(authServiceProvider).logout,
                  child: const Text('ログアウト'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
