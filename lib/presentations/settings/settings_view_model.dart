import 'package:qiita_reader/applications/auth_service/provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_view_model.g.dart';

@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  @override
  void build() {}

  Future<void> startLogout() async {
    await ref.read(authServiceProvider).logout();
  }
}
