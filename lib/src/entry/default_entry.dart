import 'package:flutter/widgets.dart';

import '../framework/log.dart';
import '../interface/system_interface.dart';
import '../type/app_runner.dart';
import '../type/plugin_list.dart';
import '../values/tag.dart';
import '../widget/inherited.dart';

/// 无法正确加载平台时的实现
final class DefaultEntry extends FreeFEOSInterface {
  DefaultEntry();

  /// 入口函数
  @override
  Future<void> runApp({
    required AppRunner runner,
    required PluginList plugins,
    required Widget app,
    required dynamic error,
  }) async {
    return await () async {
      try {
        return await runner(
          ExecutorInherited(
            executor: (
              String channel,
              String method, [
              dynamic arguments,
            ]) async {
              return Log.w(
                tag: entryTag,
                message: '不支持当前平台, '
                    '当前调用的插件通道: $channel, '
                    '方法名: $method, '
                    '携带参数: $arguments, '
                    '无法执行操作, 将返回空.',
              );
            },
            child: app,
          ),
        ).then(
          (_) => Log.w(
            tag: entryTag,
            message: '不支持当前平台, '
                '框架所有代码将不会参与执行, '
                '${plugins().length}个插件不会被加载.',
          ),
        );
      } catch (exception) {
        return await super.runApp(
          runner: runner,
          plugins: plugins,
          app: app,
          error: exception,
        );
      }
    }();
  }
}
