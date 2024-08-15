import '../interface/system_interface.dart';
import '../type/app_builder.dart';
import '../type/app_runner.dart';
import '../type/plugin_list.dart';
import 'base.dart';

base mixin BaseEntry on FreeFEOSInterface {
  /// 入口
  @override
  Future<void> runFreeFEOSApp(
    AppRunner runner,
    PluginList plugins,
    AppBuilder app,
    Object? error,
  ) async {
    final FreeFEOSInterface interface = SystemBase()();
    try {
      return await interface.runFreeFEOSApp(runner, plugins, app, error);
    } catch (exception) {
      return await super.runFreeFEOSApp(runner, plugins, app, exception);
    }
  }
}
