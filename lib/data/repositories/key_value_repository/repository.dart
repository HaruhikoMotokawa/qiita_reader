import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qiita_reader/data/local_sources/shared_preference.dart';

/// キーバリューペアを管理するための抽象インターフェース
abstract interface class KeyValueRepositoryBase {
  /// アプリの初回起動の設定を取得
  Future<bool?> getIsFirstLogin();

  /// アプリの初回起動の設定を保存
  Future<void> setIsFirstLogin({bool? value});
}

/// アプリケーションのキー・バリュー設定を管理するクラス
class KeyValueRepository implements KeyValueRepositoryBase {
  KeyValueRepository(this.ref);

  final ProviderRef<dynamic> ref;

  /// 初めてログインしたかのフラグのキー
  static const isFirstLoginKey = 'isFirstLogin';

  @override
  Future<bool?> getIsFirstLogin() async => _get<bool>(isFirstLoginKey);

  @override
  Future<void> setIsFirstLogin({bool? value}) => _set(isFirstLoginKey, value);

  /// 指定されたキーに関連付けられたデータをSharedPreferencesから取得します。
  ///
  /// [key] には取得したいデータのキーを指定します。
  /// この関数は、ジェネリック型[T]に基づいて適切なデータ型の取得を試みます。
  ///
  /// 型[T]に応じて以下の取得方法が使用されます:
  /// - `int`: SharedPreferences.getIntを使用して整数を取得。
  /// - `double`: SharedPreferences.getDoubleを使用して浮動小数点数を取得。
  /// - `String`: SharedPreferences.getStringを使用して文字列を取得。
  /// - `bool`: SharedPreferences.getBoolを使用してブーリアン値を取得。
  /// - `DateTime`: 文字列として保存された日時を[DateTime.parse]を使用して解析。
  /// - `List`: JSON文字列として保存されたリストを`json.decode`を使用して解析。
  /// - `Map`: JSON文字列として保存されたマップを`json.decode`を使用して解析。
  ///
  /// [T]がサポートされていない型の場合、[UnsupportedError]がスローされます。
  ///
  /// この関数は非同期であり、結果は`Future<T?>`として返されます。
  ///
  /// @param key 取得したいデータのキー。
  /// @return [Future<T?>] 取得したデータを含むFuture、もしくはnull。
  /// @throws [UnsupportedError] 指定された型がサポートされていない場合。
  Future<T?> _get<T>(String key) async {
    final pref = await ref.read(sharedPreferencesProvider.future);

    switch (T) {
      case int:
        return pref.getInt(key) as T?;
      case double:
        return pref.getDouble(key) as T?;
      case String:
        return pref.getString(key) as T?;
      case bool:
        return pref.getBool(key) as T?;
      case DateTime:
        return switch (pref.getString(key)) {
          final dateTimeString? => DateTime.parse(dateTimeString) as T,
          _ => null,
        };
      case const (List<dynamic>):
        final value = pref.get(key);
        if (value is List<String>) {
          return value as T?;
        }

        return switch (value) {
          final String stringValue => json.decode(stringValue) as T,
          _ => null,
        };
      case const (Map<dynamic, dynamic>):
        return switch (pref.getString(key)) {
          final value? => json.decode(value) as T,
          _ => null,
        };
      case _:
        throw UnsupportedError('対応していない型です');
    }
  }

  /// 指定されたキーと値をSharedPreferencesに保存します。
  ///
  /// - 値の型に基づいて適切なSharedPreferencesのメソッドを使用します。
  /// - 値が`null`の場合はキーを削除します。
  /// - 値の保存後、変更があったキーを_onValueChanged Streamに通知します。
  ///
  /// `SharedPreferences`に値を保存する際、値の型に基づいて適切な保存方法を選択します。
  /// - `int`型の場合はを`SharedPreferences.setInt`を呼び出します。
  /// - `double`型の場合は、`SharedPreferences.setDouble`を呼び出します。
  /// - `bool`型の場合は、`SharedPreferences.setBool`を呼び出します。
  /// - `String`型の場合は、`SharedPreferences.setString`を呼び出します。
  /// - `DateTime`型の場合はISO8601文字列に変換し、`SharedPreferences.setString`を呼び出します。
  /// - `List<String>`型の場合は、`SharedPreferences.setStringList`を呼び出します。
  /// - 値が`null`の場合は、対応するキーのデータを削除します。
  /// - 上記のどの型にも該当しない場合は、値をJSON文字列にエンコードし、`SharedPreferences.setString`を呼び出します。
  Future<void> _set(String key, Object? value) async {
    final pref = await ref.read(sharedPreferencesProvider.future);

    switch (value) {
      case final int intValue:
        await pref.setInt(key, intValue);
      case final double doubleValue:
        await pref.setDouble(key, doubleValue);
      case final bool boolValue:
        await pref.setBool(key, boolValue);
      case final String stringValue:
        await pref.setString(key, stringValue);
      case final DateTime dateTimeValue:
        await pref.setString(key, dateTimeValue.toIso8601String());
      case final List<String> listStringValue:
        await pref.setStringList(key, listStringValue);
      case null:
        await pref.remove(key);
      case _:
        await pref.setString(key, jsonEncode(value));
    }
  }
}
