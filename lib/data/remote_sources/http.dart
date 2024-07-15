import 'package:dio/dio.dart';
import 'package:qiita_reader/core/constants/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http.g.dart';

/// Dioのインスタンスを生成する
@Riverpod(keepAlive: true)
Dio http(HttpRef ref) {
  // baseUrlを設定すると、httpリクエストは必ずqiitaBaseUrlを使うようになる
  return Dio(BaseOptions(baseUrl: Constants.qiitaBaseUrl));
}
