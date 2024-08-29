import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../base/base.dart';
import '../framework/log.dart';
import '../plugin/plugin_details.dart';
import '../plugin/plugin_runtime.dart';
import '../plugin/plugin_type.dart';
import '../values/channel.dart';
import '../values/method.dart';
import '../values/placeholder.dart';
import '../values/strings.dart';
import '../values/tag.dart';
import '../viewmodel/system_view_model.dart';
import '../widget/about.dart';
import '../widget/ui.dart';
import '../widget/exit.dart';
import '../widget/manager.dart';
import '../widget/settings.dart';
import '../widget/sheet.dart';

/// 运行时
final class SystemRuntime extends SystemBase {
  /// 插件列表
  final List<RuntimePlugin> _pluginList = [];

  /// 插件详细信息列表
  final List<PluginDetails> _pluginDetailsList = [];

  /// 内部插件列表
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
          arguments,
        );
      case runtimeGetPlatformPlugins:
        return await super.execEngine(
          engineGetPlatformPlugins,
          arguments,
        );
      default:
        return await null;
    }
  }

  /// 初始化应用
  @override
  Future<void> init(List<RuntimePlugin> plugins) async {
    // 初始化运行时
    await _initRuntime();
    // 初始化引擎插件
    await _initEnginePlugin();
    // 初始化平台插件
    await _initPlatformPlugin();
    // 初始化普通插件
    await _initPlugins(plugins: plugins);
  }

  /// 获取App
  @override
  Widget findApplication() {
    return Builder(
      builder: (context) {
        for (var element in _pluginDetailsList) {
          if (_isRuntime(element)) {
            return _getPluginWidget(
              context,
              element,
            );
          }
        }
        return super.buildManager(context);
      },
    );
  }

  /// 构建View Model
  @override
  ChangeNotifier buildViewModel(BuildContext context) {
    return SystemViewModel(
      context: context,
      launchApplication: super.launchApplication,
      launchBottomSheet: super.launchBottomSheet,
      launchAboutDiialog: super.launchAboutDiialog,
      launchExitDialog: super.launchExitDialog,
      launchManager: super.launchManager,
      launchSettings: super.launchSettings,
      pluginDetailsList: _pluginDetailsList,
      getPlugin: _getPlugin,
      getPluginWidget: _getPluginWidget,
      isRuntime: _isRuntime,
    );
  }

  /// 构建应用
  @override
  Widget buildSystemUI(Widget child) {
    return SystemUI(
      viewModel: buildViewModel,
      attach: super.attachContext,
      manager: buildManager,
      settings: buildSettings,
      child: child,
    );
  }

  /// 构建调试菜单
  @override
  Widget buildBottomSheet(
    BuildContext context,
    bool isManager,
  ) {
    return SystemSheet(
      isManager: isManager,
    );
  }

  /// 构建关于对话框
  @override
  Widget buildAboutDialog(
    BuildContext context,
    bool isPackage,
  ) {
    return SystemAbout(
      isPackage: isPackage,
    );
  }

  /// 构建退出对话框
  @override
  Widget buildExitDialog(BuildContext context) {
    return SystemExit(
      exit: () async => await SystemNavigator.pop(),
    );
  }

  /// 构建管理器布局
  @override
  Widget buildManager(BuildContext context) {
    return const SystemManager();
  }

  /// 构建设置
  @override
  Widget buildSettings(BuildContext context) {
    return const SystemSettings(
      isManager: false,
    );
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

  /// 初始化运行时
  Future<void> _initRuntime() async {
    try {
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
    } catch (_) {
      rethrow;
    }
  }

  /// 初始化平台层插件
  Future<void> _initEnginePlugin() async {
    // 初始化平台插件
    try {
      dynamic plugins = await _exec(
        pluginChannel,
        runtimeGetEnginePlugins,
        true,
      );
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
      dynamic plugins = await _exec(
        pluginChannel,
        runtimeGetPlatformPlugins,
        true,
      );
      List list = plugins as List? ?? [unknownPluginWithJSON];
      if (list.isNotEmpty) {
        // 遍历原生插件
        for (var element in list) {
          // 添加到插件详细信息列表
          _pluginDetailsList.add(
            PluginDetails.formJSON(
              json: jsonDecode(element),
              type: PluginType.platform,
            ),
          );
        }
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
    try {
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
    } catch (_) {
      rethrow;
    }
  }

  /// 判断插件是否为运行时
  bool _isRuntime(PluginDetails details) {
    return details.channel == pluginChannel;
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

  /// 获取插件界面
  Widget _getPluginWidget(
    BuildContext context,
    PluginDetails details,
  ) {
    RuntimePlugin? plugin = _getPlugin(details);
    Widget? pluginWidget = plugin?.pluginWidget(context);
    return pluginWidget ?? const Placeholder();
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
            Log.e(
              tag: runtimeTag,
              message: '未经允许的访问!\n'
                  '通道名称:$channel.\n'
                  '方法名称:$method.\n'
                  '附加参数:$arguments.\n',
            );
            // 返回空结束函数
            return await null;
          }
        }
        if (element.pluginChannel == channel) {
          dynamic result;
          try {
            result = await element.onMethodCall(
              method,
              arguments,
            );
          } catch (exception) {
            Log.e(
              tag: runtimeTag,
              message: '运行时插件代码调用失败!\n'
                  '通道名称:$channel.\n'
                  '方法名称:$method.\n'
                  '附加参数:$arguments.\n'
                  '返回结果:$result.',
              error: exception,
            );
            rethrow;
          }
          Log.d(
            tag: runtimeTag,
            message: '运行时插件代码调用成功!\n'
                '通道名称:$channel.\n'
                '方法名称:$method.\n'
                '附加参数:$arguments.\n'
                '返回结果:$result.',
          );
          return await result;
        }
      }
    } else {
      Log.e(
        tag: runtimeTag,
        message: '运行时插件列表为空!',
      );
      return await null;
    }
  }
}
