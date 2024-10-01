import 'package:flutter/widgets.dart';

import '../framework/context.dart';
import '../framework/log.dart';
import '../interface/config.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_runtime.dart';

//--------------------  入口用  -------------------------------
typedef ApiBuilder = Future<void> Function(MethodExecer exec);
typedef AppRunner = Future<void> Function(Widget app);
typedef PluginList = List<RuntimePlugin>;
typedef AppImport = SystemImport;
typedef AppConfig = SystemConfig;
typedef MethodExecer = Future<dynamic> Function(
  String channel,
  String method, [
  dynamic arguments,
]);
//--------------------  入口用  -------------------------------
//--------------------- ViewModel ----------------------------
typedef AboutDialogLauncher = Future<dynamic> Function(bool isPackage);
typedef BottomSheetLauncher = Future<dynamic> Function(bool isManager);
typedef ContextAttacher = void Function(BuildContext context);
typedef MenuLauncher = Future<void> Function();
typedef NavigatorLauncher = Future<dynamic> Function();
typedef PluginGetter = RuntimePlugin? Function(
  PluginDetails details,
);
typedef PluginWidgetGetter = Widget Function(
  BuildContext context,
  PluginDetails details,
);
typedef RuntimeChecker = bool Function(PluginDetails details);
//--------------------- ViewModel ----------------------------
//------------------  框架  -----------------------------
typedef LoggerListener = void Function(LoggerRecord record);
typedef SystemLayout = Layout Function();
//------------------  框架  -----------------------------
//------------UI--------
typedef ViewModelBuilder = ChangeNotifier Function(BuildContext context);
//------------UI--------