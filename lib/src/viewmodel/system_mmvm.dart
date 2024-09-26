import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

import '../intl/l10n.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';
import '../type/about_dialog_launcher.dart';
import '../type/bottom_sheet_launcher.dart';
import '../type/navigator_launcher.dart';
import '../type/plugin_getter.dart';
import '../type/plugin_widget_gatter.dart';
import '../type/runtiem_checker.dart';
import '../utils/utils.dart';
import '../values/url.dart';

abstract interface class ViewModelWrapper {
  /// 打开底部弹出菜单
  Future<dynamic> openBottomSheet(bool isManager);

  /// 打开应用信息
  Future<dynamic> openAboutDialog(bool isPackage);

  /// 打开退出应用对话框
  Future<dynamic> openExitDialog();

  /// 进入应用
  void openApplication();

  /// 打开管理器
  Future<dynamic> openManager();

  /// 打开设置
  Future<dynamic> openSettings();

  /// 获取应用名称
  Future<String> getAppName();

  /// 获取应用版本
  Future<String> getAppVersion();

  /// 统计普通插件数量
  int pluginCount();

  /// 打开PubDev
  Future<bool> launchPubDev();

  /// 获取插件列表
  List<PluginDetails> get getPluginDetailsList;

  /// 获取插件图标
  Widget getPluginIcon(PluginDetails details);

  /// 获取插件类型
  String getPluginType(
    BuildContext context,
    PluginDetails details,
  );

  /// 获取插件的动作名
  String getPluginAction(
    BuildContext context,
    PluginDetails details,
  );

  /// 获取插件的提示
  String getPluginTooltip(
    BuildContext context,
    PluginDetails details,
  );

  /// 打开卡片
  VoidCallback? openPlugin(
    BuildContext context,
    PluginDetails details,
  );

  GestureTapCallback? maximizeWindow();
  GestureDragStartCallback? startDragging(
    DragStartDetails _,
  );
  VoidCallback? closeWindow();
  VoidCallback? minimizeWindow();
}

final class SystemViewModel with ChangeNotifier implements ViewModelWrapper {
  SystemViewModel({
    required this.context,
    required this.launchApplication,
    required this.launchBottomSheet,
    required this.launchAboutDiialog,
    required this.launchExitDialog,
    required this.launchManager,
    required this.launchSettings,
    required this.pluginDetailsList,
    required this.getPlugin,
    required this.getPluginWidget,
    required this.isRuntime,
  });

  /// 上下文
  final BuildContext context;

  /// 进入应用
  final VoidCallback launchApplication;

  /// 打开底部弹出菜单
  final BottomSheetLauncher launchBottomSheet;

  /// 打开应用信息
  final AboutDialogLaunch launchAboutDiialog;

  /// 打开退出应用对话框
  final NavigatorLauncher launchExitDialog;

  /// 打开管理器
  final NavigatorLauncher launchManager;

  /// 打开设置
  final NavigatorLauncher launchSettings;

  /// 插件列表
  final List<PluginDetails> pluginDetailsList;

  /// 获取插件
  final PluginGetter getPlugin;

  /// 获取插件界面
  final PluginWidgetGetter getPluginWidget;

  /// 判断是否运行时
  final RuntimeChecker isRuntime;

  /// 打开底部弹出菜单
  @override
  Future<dynamic> openBottomSheet(bool isManager) async {
    return await launchBottomSheet(isManager);
  }

  /// 打开应用信息
  @override
  Future<dynamic> openAboutDialog(bool isPackage) async {
    return await launchAboutDiialog(isPackage);
  }

  /// 打开退出应用对话框
  @override
  Future<dynamic> openExitDialog() async {
    return await launchExitDialog();
  }

  /// 进入应用
  @override
  void openApplication() {
    return launchApplication();
  }

  /// 打开管理器
  @override
  Future<dynamic> openManager() async {
    return await launchManager();
  }

  /// 打开设置
  @override
  Future<dynamic> openSettings() async {
    return await launchSettings();
  }

  /// 获取应用名称
  @override
  Future<String> getAppName() async {
    // 获取包信息
    PackageInfo info = await PackageInfo.fromPlatform();
    // 获取应用名称
    return info.appName.isNotEmpty ? info.appName : "unknown";
  }

  /// 获取应用版本
  @override
  Future<String> getAppVersion() async {
    // 获取包信息
    PackageInfo info = await PackageInfo.fromPlatform();
    // 获取应用版本
    String name = info.version.isNotEmpty ? info.version : "unknown";
    String code = info.buildNumber.isNotEmpty ? info.buildNumber : "unknown";
    return "$name\t($code)";
  }

  /// 统计普通插件数量
  @override
  int pluginCount() {
    var count = 0;
    for (var element in pluginDetailsList) {
      if (element.type == PluginType.flutter) {
        count++;
      }
    }
    return count;
  }

  String pluginNames() {
    final buffer = StringBuffer();
    for (var element in pluginDetailsList) {
      if (element.type == PluginType.flutter) {
        buffer.write('${element.title}, ');
      }
    }
    return buffer.toString();
  }

  /// 打开PubDev
  @override
  Future<bool> launchPubDev() async {
    return await launchUrl(
      Uri.parse(pubDevUrl),
    );
  }

  /// 获取插件列表
  @override
  List<PluginDetails> get getPluginDetailsList {
    return pluginDetailsList;
  }

  /// 获取插件图标
  @override
  Widget getPluginIcon(PluginDetails details) {
    switch (details.type) {
      case PluginType.base:
        return Icon(
          Icons.compare_arrows,
          size: Theme.of(context).iconTheme.size,
          color: Colors.pinkAccent,
        );
      case PluginType.runtime:
        return Icon(
          Icons.bubble_chart,
          size: Theme.of(context).iconTheme.size,
          color: Colors.pinkAccent,
        );
      case PluginType.embedder:
        return Icon(
          Icons.keyboard_double_arrow_down,
          size: Theme.of(context).iconTheme.size,
          color: Colors.pinkAccent,
        );
      case PluginType.engine:
        return Icon(
          Icons.miscellaneous_services,
          size: Theme.of(context).iconTheme.size,
          color: Colors.blueAccent,
        );
      case PluginType.platform:
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            return Icon(
              Icons.android,
              size: Theme.of(context).iconTheme.size,
              color: Colors.green,
            );
          case TargetPlatform.fuchsia:
            return Icon(
              Icons.all_inclusive,
              size: Theme.of(context).iconTheme.size,
              color: Colors.pinkAccent,
            );
          case TargetPlatform.iOS:
            return Icon(
              Icons.apple,
              size: Theme.of(context).iconTheme.size,
              color: Colors.grey,
            );
          case TargetPlatform.linux:
            return Icon(
              Icons.desktop_windows,
              size: Theme.of(context).iconTheme.size,
              color: Colors.black,
            );
          case TargetPlatform.macOS:
            return Icon(
              Icons.apple,
              size: Theme.of(context).iconTheme.size,
              color: Colors.grey,
            );
          case TargetPlatform.windows:
            return Icon(
              Icons.window,
              size: Theme.of(context).iconTheme.size,
              color: Colors.blue,
            );
          default:
            return Icon(
              Icons.question_mark,
              size: Theme.of(context).iconTheme.size,
              color: Colors.red,
            );
        }
      case PluginType.kernel:
        return Icon(
          Icons.memory,
          size: Theme.of(context).iconTheme.size,
          color: Colors.blueGrey,
        );
      case PluginType.flutter:
        return const FlutterLogo();
      case PluginType.unknown:
        return Icon(
          Icons.error,
          size: Theme.of(context).iconTheme.size,
          color: Theme.of(context).colorScheme.error,
        );
      default:
        return Icon(
          Icons.error,
          size: Theme.of(context).iconTheme.size,
          color: Theme.of(context).colorScheme.error,
        );
    }
  }

  /// 获取插件类型
  @override
  String getPluginType(
    BuildContext context,
    PluginDetails details,
  ) {
    switch (details.type) {
      // 框架运行时
      case PluginType.runtime:
        return IntlLocalizations.of(
          context,
        ).managerPluginTypeRuntime;
      // 绑定通信层
      case PluginType.base:
        return IntlLocalizations.of(
          context,
        ).managerPluginTypeBase;
      // 平台嵌入层
      case PluginType.embedder:
        return IntlLocalizations.of(
          context,
        ).managerPluginTypeEmbedder;
      // 平台插件
      case PluginType.engine:
        return IntlLocalizations.of(
          context,
        ).managerPluginTypeEngine;
      // 平台插件
      case PluginType.platform:
        return IntlLocalizations.of(
          context,
        ).managerPluginTypePlatform;
      // 内核模块
      case PluginType.kernel:
        return IntlLocalizations.of(
          context,
        ).managerPluginTypeKernel;
      // 普通插件
      case PluginType.flutter:
        return IntlLocalizations.of(
          context,
        ).managerPluginTypeFlutter;
      // 未知类型插件
      case PluginType.unknown:
        return IntlLocalizations.of(
          context,
        ).managerPluginTypeUnknown;
      // 未知
      default:
        return IntlLocalizations.of(
          context,
        ).unknown;
    }
  }

  /// 获取插件的动作名
  @override
  String getPluginAction(
    BuildContext context,
    PluginDetails details,
  ) {
    return _isAllowPush(details)
        ? isRuntime(details)
            ? IntlLocalizations.of(
                context,
              ).managerPluginActionAbout
            : IntlLocalizations.of(
                context,
              ).managerPluginActionOpen
        : IntlLocalizations.of(
            context,
          ).managerPluginActionNoUI;
  }

  /// 获取插件的提示
  @override
  String getPluginTooltip(
    BuildContext context,
    PluginDetails details,
  ) {
    return _isAllowPush(details)
        ? isRuntime(details)
            ? IntlLocalizations.of(
                context,
              ).managerPluginTooltipAbout
            : IntlLocalizations.of(
                context,
              ).managerPluginTooltipOpen
        : IntlLocalizations.of(
            context,
          ).managerPluginTooltipNoUI;
  }

  /// 打开卡片
  @override
  VoidCallback? openPlugin(
    BuildContext context,
    PluginDetails details,
  ) {
    // 无法打开的返回空
    return _isAllowPush(details)
        ? () async {
            if (!isRuntime(details)) {
              // 非运行时打开插件页面
              await _launchPlugin(context, details);
            } else {
              // 运行时打开关于对话框
              await launchAboutDiialog(true);
            }
          }
        : null;
  }

  /// 插件是否可以打开
  bool _isAllowPush(PluginDetails details) {
    return (details.type == PluginType.runtime ||
            details.type == PluginType.flutter) &&
        getPlugin(details) != null;
  }

  /// 打开插件
  Future<dynamic> _launchPlugin(
    BuildContext host,
    PluginDetails details,
  ) async {
    return await Navigator.of(
      host,
      rootNavigator: true,
    ).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(details.title),
            ),
            body: getPluginWidget(
              context,
              details,
            ),
          );
        },
      ),
    );
  }

  @override
  GestureTapCallback? maximizeWindow() {
    return () async {
      if (kIsDesktop) {
        if (!await windowManager.isMaximized()) {
          await windowManager.maximize();
        } else {
          await windowManager.unmaximize();
        }
      }
    };
  }

  @override
  GestureDragStartCallback? startDragging(DragStartDetails _) {
    return (_) async => await windowManager.startDragging();
  }

  @override
  VoidCallback? closeWindow() {
    return () async => await windowManager.destroy();
  }

  @override
  VoidCallback? minimizeWindow() {
    return () async => await windowManager.minimize();
  }
}
