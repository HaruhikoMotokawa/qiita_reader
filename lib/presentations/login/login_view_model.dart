import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qiita_reader/applications/auth_service/provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_view_model.freezed.dart';
part 'login_view_model.g.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState() = _LoginState;
}

@Riverpod(keepAlive: true)
class LoginViewModel extends _$LoginViewModel {
  @override
  LoginState build() {
    return const LoginState();
  }

  Future<void> startLogin() async {
    await ref.read(authServiceProvider).login();
  }
}
