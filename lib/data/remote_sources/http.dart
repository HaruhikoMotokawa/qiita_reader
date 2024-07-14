import 'package:dio/dio.dart';
import 'package:qiita_reader/core/constants/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http.g.dart';

@Riverpod(keepAlive: true)
Dio http(HttpRef ref) {
  return Dio(BaseOptions(baseUrl: Constants.qiitaBaseUrl));
}
