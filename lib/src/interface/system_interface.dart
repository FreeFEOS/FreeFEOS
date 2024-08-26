import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../entry/default_entry.dart';
import '../type/app_runner.dart';
import '../type/plugin_list.dart';

/// 实现平台接口的抽象类
abstract class FreeFEOSInterface extends PlatformInterface {
  FreeFEOSInterface() : super(token: _token);

  /// 令牌
  static final Object _token = Object();

  /// 实例
  static FreeFEOSInterface _instance = DefaultEntry();

  /// 获取实例
  static FreeFEOSInterface get instance => _instance;

  /// 设置实例
  static set instance(FreeFEOSInterface instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// 实现的接口
  FreeFEOSInterface get interface => instance;

  /// 运行应用
  Future<void> runFreeFEOSApp({
    required AppRunner runner,
    required PluginList plugins,
    required Widget app,
    required dynamic error,
  }) async {
    if (error != null) {
      throw Exception(error);
    } else {
      throw UnimplementedError('未实现runFreeFEOSApp方法');
    }
  }

  Future<dynamic> execPluginMethod(
    String channel,
    String method,
    dynamic error, [
    dynamic arguments,
  ]) async {
    if (error != null) {
      throw Exception(error);
    } else {
      throw UnimplementedError('未实现execPluginMethod方法');
    }
  }
}
