import 'package:flutter/widgets.dart';

import '../framework/log.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_runtime.dart';

typedef AboutDialogLauncher = Future<dynamic> Function(bool isPackage);
typedef ApiBuilder = Future<void> Function(MethodExecer exec);
typedef AppRunner = Future<void> Function(Widget app);
typedef BottomSheetLauncher = Future<dynamic> Function(bool isManager);
typedef ContextAttacher = void Function(BuildContext context);
typedef LoggerListener = void Function(LoggerRecord record);

/// 入口用
typedef MenuLauncher = Future<void> Function();

/// 入口用
typedef MethodExecer = Future<dynamic> Function(
  String channel,
  String method, [
  dynamic arguments,
]);
typedef NavigatorLauncher = Future<dynamic> Function();
typedef PluginGetter = RuntimePlugin? Function(
  PluginDetails details,
);

/// 入口用
typedef PluginList = List<RuntimePlugin> Function();
typedef PluginWidgetGetter = Widget Function(
  BuildContext context,
  PluginDetails details,
);
typedef RuntimeChecker = bool Function(PluginDetails details);
typedef ViewModelBuilder = ChangeNotifier Function(BuildContext context);
