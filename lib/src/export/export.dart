import 'package:flutter/widgets.dart';

import '../entry/system_entry.dart';
import '../interface/system_interface.dart';
import '../plugin/plugin_runtime.dart';

/// 注册 freefeos 插件
///
/// 此方法用于通过注册器向Flutter框架注册此插件.
/// 插件注册由Flutter框架接管, 请勿手动注册.
void registerFreeFEOS() => FreeFEOSInterface.instance = SystemEntry();

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
