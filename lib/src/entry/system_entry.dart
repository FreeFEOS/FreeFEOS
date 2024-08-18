import '../base/base_entry.dart';
import '../interface/system_interface.dart';
import '../type/app_builder.dart';
import '../type/app_runner.dart';
import '../type/plugin_list.dart';

final class SystemEntry extends FreeFEOSInterface with BaseEntry {
  SystemEntry();

  /// 入口函数
  @override
  Future<void> runFreeFEOSApp({
    required AppRunner runner,
    required PluginList plugins,
    required AppBuilder app,
    dynamic error,
  }) async {
    try {
      return await interface.runFreeFEOSApp(
        runner: runner,
        plugins: plugins,
        app: app,
        error: error,
      );
    } catch (exception) {
      return await super.runFreeFEOSApp(
        runner: runner,
        plugins: plugins,
        app: app,
        error: exception,
      );
    }
  }
}
