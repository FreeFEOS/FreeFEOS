import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freefeos/src/widget/info.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../base/base.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_runtime.dart';
import '../plugin/plugin_type.dart';
import '../values/channel.dart';
import '../values/method.dart';
import '../values/placeholder.dart';
import '../values/strings.dart';
import '../viewmodel/manager_view_model.dart';
import '../widget/exit.dart';
import '../widget/manager.dart';
import '../widget/settings.dart';
import '../widget/sheet.dart';

/// 运行时
final class SystemRuntime extends SystemBase {
  /// 应用名称
  late String _appName;

  /// 应用版本
  late String _appVersion;

  /// 插件列表
  final List<RuntimePlugin> _pluginList = [];

  /// 插件详细信息列表
  final List<PluginDetails> _pluginDetailsList = [];

  List<RuntimePlugin> get innerList => [
        super.base,
        this,
        super.embedder,
      ];

  /// 插件通道
  @override
  String get pluginChannel => runtimeChannel;

  /// 插件描述
  @override
  String get pluginDescription => runtimeDescription;

  /// 插件名称
  @override
  String get pluginName => runtimeName;

  /// 方法调用
  @override
  Future<dynamic> onMethodCall(
    String method, [
    dynamic arguments,
  ]) async {
    switch (method) {
      case runtimeGetEnginePlugins:
        return await super.execEngine(
          engineGetEnginePlugins,
        );
      case runtimeGetPlatformPlugins:
        return await super.execEngine(
          engineGetPlatformPlugins,
        );
      default:
        return await null;
    }
  }

  @override
  Future<void> init(List<RuntimePlugin> plugins) async {
    // 初始化包信息
    await _initPackage();
    // 初始化运行时
    await _initRuntime();
    // 初始化引擎插件
    await _initEnginePlugin();
    // 初始化平台插件
    await _initPlatformPlugin();
    // 初始化普通插件
    await _initPlugins(plugins: plugins);
  }

  /// 获取管理器
  @override
  Widget buildManager(BuildContext context) {
    for (var element in _pluginDetailsList) {
      if (_isRuntime(element)) {
        return _getPluginWidget(
          context,
          element,
        );
      }
    }
    return super.buildManager(context);
  }

  @override
  ChangeNotifier buildViewModel(BuildContext context) {
    return ManagerViewModel(
      context: context,
      pluginDetailsList: _pluginDetailsList,
      getPlugin: _getPlugin,
      getPluginWidget: _getPluginWidget,
      isRuntime: _isRuntime,
      launchBottomSheet: super.launchBottomSheet,
      launchExitDialog: super.launchExitDialog,
      launchManager: super.launchManager,
      launchInfo: super.launchInfo,
      launchSettings: super.launchSettings,
      appName: _appName,
      appVersion: _appVersion,
    );
  }

  /// 管理器布局
  @override
  Widget buildLayout(BuildContext context) {
    return const SystemManager();
  }

  /// 构建调试菜单
  @override
  Widget buildBottomSheet(
    BuildContext context,
    bool isManager,
  ) {
    return SheetMenu(
      appName: _appName,
      appVersion: _appVersion,
      isManageer: isManager,
    );
  }

  @override
  Widget buildExitDialog(BuildContext context) {
    return ExitDialog(
      exit: () => SystemNavigator.pop(),
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return const SettingsPage(isManageer: false);
  }

  @override
  Widget buildInfo(BuildContext context) {
    return const InfoPage();
  }

  /// 执行插件方法
  @override
  Future<dynamic> exec(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    return await _exec(
      channel,
      method,
      false,
      arguments,
    );
  }

  /// 初始化包信息
  Future<void> _initPackage() async {
    // 获取包信息
    PackageInfo info = await PackageInfo.fromPlatform();
    // 获取应用名称
    _appName = info.appName.isNotEmpty ? info.appName : "unknown";
    // 获取应用版本
    String name = info.version.isNotEmpty ? info.version : "unknown";
    String code = info.buildNumber.isNotEmpty ? info.buildNumber : "unknown";
    _appVersion = "$name\t($code)";
  }

  /// 初始化运行时
  Future<void> _initRuntime() async {
    // 初始化运行时
    for (var element in innerList) {
      // 类型
      PluginType type = PluginType.unknown;
      // 判断
      switch (element.pluginChannel) {
        case baseChannel:
          type = PluginType.base;
          break;
        case runtimeChannel:
          type = PluginType.runtime;
          break;
        case embedderChannel:
          type = PluginType.embedder;
          break;
        default:
          type = PluginType.unknown;
          break;
      }
      // 添加到内置插件列表
      _pluginList.add(element);
      // 添加到插件详细信息列表
      _pluginDetailsList.add(
        PluginDetails(
          channel: element.pluginChannel,
          title: element.pluginName,
          description: element.pluginDescription,
          author: element.pluginAuthor,
          type: type,
        ),
      );
    }
  }

  /// 初始化平台层插件
  Future<void> _initEnginePlugin() async {
    // 初始化平台插件
    try {
      dynamic plugins =
          await _exec(pluginChannel, runtimeGetEnginePlugins, true);
      List list = plugins as List? ?? [unknownPluginWithMap];
      // 判断列表是否为空
      if (list.isNotEmpty) {
        // 遍历原生插件
        for (var element in list) {
          // 添加到插件详细信息列表
          _pluginDetailsList.add(
            PluginDetails.formMap(
              map: element,
              type: PluginType.engine,
            ),
          );
        }
      }
    } catch (exception) {
      // 平台错误添加未知插件占位
      _pluginDetailsList.add(
        PluginDetails.formMap(
          map: unknownPluginWithMap,
          type: PluginType.unknown,
        ),
      );
    }
  }

  /// 初始化平台层插件
  Future<void> _initPlatformPlugin() async {
    // 初始化平台插件
    try {
      // 遍历原生插件
      for (var element
          in (await _exec(pluginChannel, runtimeGetPlatformPlugins, true)
                  as List? ??
              [unknownPluginWithJSON])) {
        // 添加到插件详细信息列表
        _pluginDetailsList.add(
          PluginDetails.formJSON(
            json: jsonDecode(element),
            type: PluginType.platform,
          ),
        );
      }
    } catch (exception) {
      // 平台错误添加未知插件占位
      _pluginDetailsList.add(
        PluginDetails.formJSON(
          json: jsonDecode(unknownPluginWithJSON),
          type: PluginType.unknown,
        ),
      );
    }
  }

  /// 初始化普通插件
  Future<void> _initPlugins({
    required List<RuntimePlugin> plugins,
  }) async {
    if (plugins.isNotEmpty) {
      for (var element in plugins) {
        _pluginList.add(element);
        _pluginDetailsList.add(
          PluginDetails(
            channel: element.pluginChannel,
            title: element.pluginName,
            description: element.pluginDescription,
            author: element.pluginAuthor,
            type: PluginType.flutter,
          ),
        );
      }
    }
  }

  /// 执行插件方法
  Future<dynamic> _exec(
    String channel,
    String method,
    bool internal, [
    dynamic arguments,
  ]) async {
    // 判断插件列表是否非空
    if (_pluginList.isNotEmpty) {
      // 遍历插件列表
      for (var element in _pluginList) {
        // 遍历内部插件列表
        for (var internalPlugin in innerList) {
          // 判断是否为内部插件, 且是否不允许访问内部插件
          if (internalPlugin.pluginChannel == channel && !internal) {
            // 返回空结束函数
            return await null;
          }
        }
        if (element.pluginChannel == channel) {
          try {
            return await element.onMethodCall(method, arguments);
          } catch (exception) {
            rethrow;
          }
        }
      }
    } else {
      return await null;
    }
  }

  /// 判断插件是否为运行时
  bool _isRuntime(PluginDetails details) {
    return details.channel == pluginChannel;
  }

  /// 获取插件界面
  Widget _getPluginWidget(
    BuildContext context,
    PluginDetails details,
  ) {
    return _getPlugin(details)?.pluginWidget(context) ?? const Placeholder();
  }

  /// 获取插件
  RuntimePlugin? _getPlugin(PluginDetails details) {
    if (_pluginList.isNotEmpty) {
      for (var element in _pluginList) {
        if (element.pluginChannel == details.channel) {
          return element;
        }
      }
    }
    return null;
  }
}
