import 'dart:async';

import 'package:qiita_reader/applications/auth_service/provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  void build() {}

  Future<void> startLogin() async {
    await ref.read(authServiceProvider).login();
  }
}
