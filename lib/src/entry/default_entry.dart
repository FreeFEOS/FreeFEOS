import 'package:flutter/widgets.dart';

import '../framework/log.dart';
import '../interface/system_interface.dart';
import '../type/api_builder.dart';
import '../type/app_runner.dart';
import '../type/plugin_list.dart';
import '../values/tag.dart';

/// 无法正确加载平台时的实现
final class DefaultEntry extends FreeFEOSInterface {
  DefaultEntry();

  /// 入口函数
  @override
  Future<void> runFreeFEOSApp({
    required AppRunner runner,
    required PluginList plugins,
    required ApiBuilder initApi,
    required Widget app,
    required bool enabled,
    required dynamic error,
  }) async {
    return await () async {
      try {
        if (enabled) {
          await initApi(
            (
              String channel,
              String method, [
              dynamic arguments,
            ]) async {
              Log.w(
                tag: entryTag,
                message: '不支持当前平台,\n'
                    '当前调用的插件通道: $channel,\n'
                    '方法名: $method,\n'
                    '携带参数: $arguments,\n'
                    '无法执行操作, 将返回空.',
              );
              return await null;
            },
          );
          return await runner(app).then(
            (_) => Log.w(
              tag: entryTag,
              message: '不支持当前平台,\n'
                  '框架所有代码将不会参与执行,\n'
                  '${plugins().length}个插件不会被加载.\n',
            ),
          );
        } else {
          return await runner(app);
        }
      } catch (exception) {
        return await super.runFreeFEOSApp(
          runner: runner,
          plugins: plugins,
          initApi: initApi,
          app: app,
          enabled: enabled,
          error: exception,
        );
      }
    }();
  }
}
