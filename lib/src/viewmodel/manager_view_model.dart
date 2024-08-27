import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freefeos/src/type/navigator_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../intl/l10n.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';
import '../type/bottom_sheet_launcher.dart';
import '../type/plugin_getter.dart';
import '../type/plugin_widget_gatter.dart';
import '../type/runtiem_checker.dart';
import '../values/url.dart';
import 'view_model_wrapper.dart';

final class ManagerViewModel with ChangeNotifier implements ViewModelWrapper {
  ManagerViewModel({
    required this.context,
    required this.pluginDetailsList,
    required this.getPlugin,
    required this.getPluginWidget,
    required this.isRuntime,
    required this.launchBottomSheet,
    required this.launchExitDialog,
    required this.launchManager,
    required this.launchInfo,
    required this.launchSettings,
    required this.appName,
    required this.appVersion,
  });

  /// 上下文
  final BuildContext context;

  /// 插件列表
  final List<PluginDetails> pluginDetailsList;

  /// 获取插件
  final PluginGetter getPlugin;

  /// 获取插件界面
  final PluginWidgetGetter getPluginWidget;

  /// 判断是否运行时
  final RuntimeChecker isRuntime;

  /// 打开对话框
  final BottomSheetLauncher launchBottomSheet;
  final NavigatorLauncher launchExitDialog;
  final NavigatorLauncher launchManager;
  final NavigatorLauncher launchInfo;
  final NavigatorLauncher launchSettings;

  /// 应用名称
  final String appName;

  /// 应用版本
  final String appVersion;

  /// 打开对话框
  @override
  Future<dynamic> bottomSheet(bool isManager) async {
    return await launchBottomSheet.call(isManager);
  }

  @override
  Future<dynamic> exitDialog() async {
    return await launchExitDialog.call();
  }

  @override
  Future<dynamic> openInfo() async {
    return await launchInfo.call();
  }

  @override
  Future<dynamic> openManager() async {
    return await launchManager.call();
  }

  @override
  Future<dynamic> openSettings() async {
    return await launchSettings.call();
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
        ).pluginTypeRuntime;
      // 绑定通信层
      case PluginType.base:
        return IntlLocalizations.of(
          context,
        ).pluginTypeBase;
      // 平台嵌入层
      case PluginType.embedder:
        return IntlLocalizations.of(
          context,
        ).pluginTypeEmbedder;
      // 平台插件
      case PluginType.engine:
        return IntlLocalizations.of(
          context,
        ).pluginTypeEngine;
      // 平台插件
      case PluginType.platform:
        return IntlLocalizations.of(
          context,
        ).pluginTypePlatform;
      // 内核模块
      case PluginType.kernel:
        return IntlLocalizations.of(
          context,
        ).pluginTypeKernel;
      // 普通插件
      case PluginType.flutter:
        return IntlLocalizations.of(
          context,
        ).pluginTypeFlutter;
      // 未知类型插件
      case PluginType.unknown:
        return IntlLocalizations.of(
          context,
        ).pluginTypeUnknown;
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
              ).pluginActionAbout
            : IntlLocalizations.of(
                context,
              ).pluginActionOpen
        : IntlLocalizations.of(
            context,
          ).pluginActionNoUI;
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
              ).pluginTooltipOpen
            : IntlLocalizations.of(
                context,
              ).pluginTooltipAbout
        : IntlLocalizations.of(
            context,
          ).pluginTooltipNoUI;
  }

  /// 打开卡片
  @override
  VoidCallback? openPlugin(
    BuildContext context,
    PluginDetails details,
  ) {
    // 无法打开的返回空
    return _isAllowPush(details)
        ? () {
            if (!isRuntime(details)) {
              // 非运行时打开插件页面
              _launchPlugin(context, details);
            } else {
              // 运行时打开关于对话框
              showAboutDialog(
                context: context,
                applicationName: appName,
                applicationVersion: appVersion,
                applicationLegalese: IntlLocalizations.of(
                  context,
                ).openPluginText,
                useRootNavigator: true,
              );
            }
          }
        : null;
  }

  @override
  String get getAppName {
    return appName;
  }

  @override
  String get getAppVersion {
    return appVersion;
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
}
