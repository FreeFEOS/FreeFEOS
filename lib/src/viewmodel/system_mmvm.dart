import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freefeos/src/interface/config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

import '../framework/context.dart';
import '../intl/l10n.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_type.dart';
import '../type/types.dart';
import '../utils/utils.dart';
import '../values/route.dart';
import '../values/url.dart';
import '../widget/about.dart';

abstract interface class ISystemViewModel {
  /// 附加构建上下文
  void attachBuildContext(BuildContext context);

  /// 获取应用名称
  Future<String> getAppName();

  /// 获取应用版本
  Future<String> getAppVersion();

  /// 统计普通插件数量
  String pluginCount();

  /// 获取所有普通插件的名称
  String pluginNames();

  /// 打开PubDev
  Future<bool> launchPubDev();

  /// 获取插件列表
  List<PluginDetails> get getPluginDetailsList;

  /// 获取插件图标
  Widget getPluginIcon(
    BuildContext context,
    PluginDetails details,
  );

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

  /// 最大化窗口
  Future<void> maximizeWindow();

  /// 拖动窗口
  Future<void> startDragging();

  /// 关闭窗口
  Future<void> closeWindow();

  /// 最小化窗口
  Future<void> minimizeWindow();

  /// 退出
  Future<void> exitApp();

  /// 获取当前插件的详细信息
  PluginDetails get getCurrentDetails;

  /// 获取插件界面
  PluginWidgetGetter get getPluginWidget;

  Widget get getChild;
}

final class SystemViewModel extends ContextWrapper
    with ViewModel
    implements ISystemViewModel {
  /// 构造函数
  SystemViewModel({
    required BuildContext context,
    required this.contextAttacher,
    required this.config,
    required this.pluginDetailsList,
    required this.pluginGetter,
    required this.pluginWidgetGetter,
    required this.runtimeChecker,
    required this.child,
  }) : super(attach: true) {
    attachBuildContext(context);
  }

  /// 上下文附加器
  final ContextAttacher contextAttacher;

  final SystemConfig config;

  /// 插件列表
  final List<PluginDetails> pluginDetailsList;

  /// 获取插件
  final PluginGetter pluginGetter;

  /// 获取插件界面
  final PluginWidgetGetter pluginWidgetGetter;

  /// 判断是否运行时
  final RuntimeChecker runtimeChecker;

  final Widget child;

  /// 当前插件的详细信息 [PluginUI] 用
  PluginDetails? _currentDetails;

  /// 附加构建上下文
  @override
  void attachBuildContext(BuildContext context) {
    return contextAttacher(context);
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
  String pluginCount() {
    var count = 0;
    for (var element in pluginDetailsList) {
      if (element.type == PluginType.flutter) {
        count++;
      }
    }
    return count.toString();
  }

  /// 获取所有普通插件名称的集合
  @override
  String pluginNames() {
    final buffer = StringBuffer();
    for (var element in pluginDetailsList) {
      if (element.type == PluginType.flutter) {
        buffer.write('${element.title}\n');
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
  Widget getPluginIcon(
    BuildContext context,
    PluginDetails details,
  ) {
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
        ? runtimeChecker(details)
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
        ? runtimeChecker(details)
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
        ? () {
            if (!runtimeChecker(details)) {
              // 非运行时打开插件页面
              _currentDetails = details;
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed(routePlugin);
            } else {
              // 运行时打开关于对话框
              showDialog(
                context: context,
                useRootNavigator: true,
                builder: (context) => const SystemAbout(
                  isPackage: true,
                ),
              );
            }
          }
        : null;
  }

  /// 插件是否可以打开
  bool _isAllowPush(PluginDetails details) {
    return (details.type == PluginType.runtime ||
            details.type == PluginType.flutter) &&
        pluginGetter(details) != null;
  }

  @override
  Future<void> maximizeWindow() async {
    if (PlatformUtil.kIsDesktop) {
      return !await windowManager.isMaximized()
          ? await windowManager.maximize()
          : await windowManager.unmaximize();
    }
  }

  @override
  Future<void> startDragging() async {
    if (PlatformUtil.kIsDesktop) {
      return await windowManager.startDragging();
    }
  }

  @override
  Future<void> closeWindow() async {
    if (PlatformUtil.kIsDesktop) {
      return await windowManager.close();
    }
  }

  @override
  Future<void> minimizeWindow() async {
    if (PlatformUtil.kIsDesktop) {
      return await windowManager.minimize();
    }
  }

  @override
  Future<void> exitApp() async {
    return PlatformUtil.kIsDesktop
        ? await windowManager.destroy()
        : await SystemNavigator.pop();
  }

  @override
  PluginDetails get getCurrentDetails {
    assert(() {
      if (_currentDetails == null) {
        throw Exception('currentDetails is null.');
      }
      return true;
    }());
    return _currentDetails!;
  }

  @override
  PluginWidgetGetter get getPluginWidget => pluginWidgetGetter;

  @override
  Widget get getChild => child;
}
