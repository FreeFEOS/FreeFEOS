import 'package:flutter/widgets.dart';

import '../base/base_entry.dart';
import '../interface/system_interface.dart';
import '../type/api_builder.dart';
import '../type/app_runner.dart';
import '../type/plugin_list.dart';

final class SystemEntry extends FreeFEOSInterface with BaseEntry {
  SystemEntry();

  /// 入口函数
  @override
  Future<void> runFreeFEOSApp({
    required AppRunner runner,
    required PluginList plugins,
    required ApiBuilder initApi,
    required Widget app,
    required dynamic error,
  }) async {
    return await () async {
      try {
        return await interface.runFreeFEOSApp(
          runner: runner,
          plugins: plugins,
          initApi: initApi,
          app: app,
          error: error,
        );
      } catch (exception) {
        return await super.runFreeFEOSApp(
          runner: runner,
          plugins: plugins,
          initApi: initApi,
          app: app,
          error: exception,
        );
      }
    }();
  }
}
