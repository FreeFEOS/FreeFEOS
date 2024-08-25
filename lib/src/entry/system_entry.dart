import 'package:flutter/widgets.dart';

import '../base/base_entry.dart';
import '../interface/system_interface.dart';
import '../type/app_builder.dart';
import '../type/app_runner.dart';
import '../type/plugin_list.dart';

final class SystemEntry extends FreeFEOSInterface with BaseEntry {
  SystemEntry();

  /// 入口函数
  @override
  Future<void> runApp({
    required AppRunner runner,
    required PluginList plugins,
    required ApiBuilder api,
    required Widget app,
    required dynamic error,
  }) async {
    return await () async {
      try {
        return await interface.runApp(
          runner: runner,
          plugins: plugins,
          api: api,
          app: app,
          error: error,
        );
      } catch (exception) {
        return await super.runApp(
          runner: runner,
          plugins: plugins,
          api: api,
          app: app,
          error: exception,
        );
      }
    }();
  }
}
