import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: navigationShell.currentIndex,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.list_alt),
          label: '一覧',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings),
          label: '設定',
        ),
      ],
      onDestinationSelected: _select,
    );
  }

  void _select(int index) {
    // ナビゲーションシェルのページを切り替える
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
