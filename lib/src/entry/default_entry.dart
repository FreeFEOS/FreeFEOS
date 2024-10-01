import 'package:flutter/widgets.dart';

import '../framework/log.dart';
import '../interface/config.dart';
import '../interface/system_interface.dart';

import '../values/tag.dart';

/// 无法正确加载平台时的实现
final class DefaultEntry extends FreeFEOSInterface {
  DefaultEntry();

  /// 入口函数
  @override
  Future<void> runFreeFEOSApp({
    required SystemImport import,
    required SystemConfig config,
    required Widget app,
    required dynamic error,
  }) async {
    return (config.enabled ?? false)
        ? () async {
            try {
              await (import.initApi ?? (_) async {})(
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
              return await (import.runner ?? (app) async => runApp(app))(app)
                  .then(
                (_) => Log.w(
                  tag: entryTag,
                  message: '不支持当前平台,\n'
                      '框架所有代码将不会参与执行,\n'
                      '${(import.plugins ?? []).length}个插件不会被加载.\n',
                ),
              );
            } catch (exception) {
              return await super.runFreeFEOSApp(
                import: import,
                config: config,
                app: app,
                error: exception,
              );
            }
          }()
        : (import.runner ?? (app) async => runApp(app))(app);
  }
}
