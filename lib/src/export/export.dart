import 'package:flutter/widgets.dart';

import '../entry/system_entry.dart';
import '../interface/platform_interface.dart';
import '../interface/system_interface.dart';
import '../platform/freefeos_method_channel.dart';
import '../plugin/plugin_runtime.dart';

abstract base class FreeFEOSBase {
  const FreeFEOSBase();

  /// 注册 freefeos 插件
  ///
  /// 此方法用于通过注册器向Flutter框架注册此插件.
  /// 插件注册由Flutter框架接管, 请勿手动注册.
  ///
  /// 此方法为内部方法通过导出接口时的权限控制.
  void call() {
    FreeFEOSInterface.instance = SystemEntry();
    FreeFEOSPlatform.instance = MethodChannelFreeFEOS();
  }
}

abstract interface class FreeFEOSPlugin extends RuntimePlugin {}

Future<void> runFreeFEOSApp({
  required Future<void> Function(Widget app) runner,
  required List<FreeFEOSPlugin> Function() plugins,
  required Widget Function(
    BuildContext context,
    Future<void> Function() open,
    Future<dynamic> Function(
      String channel,
      String method, [
      dynamic arguments,
    ]) exec,
  ) app,
}) async {
  return await FreeFEOSInterface.instance.runFreeFEOSApp(
    runner: runner,
    plugins: plugins,
    app: app,
  );
}
