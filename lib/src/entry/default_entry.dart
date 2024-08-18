import 'dart:io';

import 'package:flutter/widgets.dart';

import '../framework/log.dart';
import '../interface/system_interface.dart';
import '../type/app_builder.dart';
import '../type/app_runner.dart';
import '../type/plugin_list.dart';
import '../utils/platform.dart';
import '../values/tag.dart';

/// 无法正确加载平台时的实现
final class DefaultEntry extends FreeFEOSInterface {
  DefaultEntry();

  /// 入口函数
  @override
  Future<void> runFreeFEOSApp({
    required AppRunner runner,
    required PluginList plugins,
    required AppBuilder app,
    dynamic error,
  }) async {
    late String platformName;
    // 获取当前操作系统名称
    if (kIsWebBroser) {
      platformName = 'Web浏览器';
    } else {
      platformName = Platform.operatingSystem;
    }
    return await () async {
      try {
        return await runner(
          Builder(
            builder: (context) => app(
              context,
              () async {
                Log.w(
                  tag: entryTag,
                  message: '不支持当前平台: $platformName, '
                      '无法打开调试对话框.',
                );
              },
              (
                String channel,
                String method, [
                dynamic arguments,
              ]) async {
                Log.w(
                  tag: entryTag,
                  message: '不支持当前平台: $platformName, '
                      '当前调用的插件通道: $channel, '
                      '方法名: $method, '
                      '携带参数: $arguments, '
                      '无法执行操作, 将返回空.',
                );
              },
            ),
          ),
        ).then(
          (_) => Log.w(
            tag: entryTag,
            message: '不支持当前平台: $platformName, '
                '框架所有代码将不会参与执行, '
                '${plugins().length}个插件不会被加载.',
          ),
        );
      } catch (exception) {
        return await super.runFreeFEOSApp(
          runner: runner,
          plugins: plugins,
          app: app,
          error: exception,
        );
      }
    }();
  }
}
