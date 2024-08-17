import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// アプリのナビゲーションバーを設定する
class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    required this.navigationShell,
    super.key,
  });

  /// StatefulShellRouteの状態を管理するウィジェット
  ///
  /// go_routerの機能
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      // StatefulNavigationShellが保持している現在のインデックスを割り当てる
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
      backgroundColor: const Color.fromARGB(255, 90, 188, 64),
    );
  }

  /// タブをタップした際の処理
  ///
  /// 引数のインデックスに該当するブランチに移動し、
  void _select(int index) {
    // ナビゲーションシェルのページを切り替える
    navigationShell.goBranch(
      // 移動するブランチのインデックス
      index,
      // ブランチのルートページに戻すかどうか
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
