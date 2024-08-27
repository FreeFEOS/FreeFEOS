import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../embedder/embedder_mixin.dart';
import '../engine/bridge_mixin.dart';
import '../plugin/plugin_runtime.dart';
import '../type/api_builder.dart';
import '../type/app_runner.dart';
import '../type/plugin_list.dart';
import '../values/channel.dart';
import '../values/route.dart';
import '../values/strings.dart';
import '../values/tag.dart';
import '../framework/context_wrapper.dart';
import '../framework/log.dart';
import '../kernel/kernel_bridge.dart';
import '../kernel/kernel_module.dart';
import '../interface/system_interface.dart';
import '../runtime/runtime_mixin.dart';
import '../values/drawable.dart';
import '../server/server.dart';
import '../widget/app.dart';
import '../widget/exit.dart';
import '../widget/provider.dart';
import 'base_entry.dart';
import 'base_mixin.dart';
import 'base_wrapper.dart';

base class SystemBase extends ContextWrapper
    with
        RuntimeMixin,
        BaseEntry,
        BaseMixin,
        EmbedderMixin,
        KernelBridgeMixin,
        ServerBridgeMixin,
        EngineBridgeMixin,
        ChangeNotifier
    implements RuntimePlugin, FreeFEOSInterface, KernelModule, BaseWrapper {
  /// 构造函数
  SystemBase() : super(attach: true);

  /// 插件作者
  @override
  String get pluginAuthor => developerName;

  /// 插件通道
  @override
  String get pluginChannel => baseChannel;

  /// 插件描述
  @override
  String get pluginDescription => baseDescription;

  /// 插件名称
  @override
  String get pluginName => baseName;

  /// 插件界面
  @override
  Widget pluginWidget(BuildContext context) {
    return ManagerProvider(
      viewModel: buildViewModel(context),
      layout: buildLayout(context),
    );
  }

  /// 运行应用
  @override
  Future<void> runFreeFEOSApp({
    required AppRunner runner,
    required PluginList plugins,
    required ApiBuilder initApi,
    required Widget app,
    required dynamic error,
  }) async {
    // 初始化日志
    Log.init();
    // 打印横幅
    Log.d(
      tag: baseTag,
      message: utf8.decode(base64Decode(banner)),
    );
    // 初始化控件绑定
    WidgetsFlutterBinding.ensureInitialized();
    // 初始化内核桥接
    await initKernelBridge();
    // TODO: 内核相关操作
    //kernelBridgeScope.

    // 初始化服务桥接
    await initServerBridge();
    // TODO: 服务相关操作

    // 初始化引擎桥接
    await initEngineBridge();
    // 初始化引擎
    await engineBridgerScope.onCreateEngine(this);
    // 初始化应用
    await init(plugins.call());
    await initApi.call(
      (
        String channel,
        String method, [
        dynamic arguments,
      ]) async {
        return await exec(
          channel,
          method,
          arguments,
        );
      },
    );
    // 启动应用
    return await runner.call(
      FreeFEOSApp(
        wrapper: this,
        open: buildBottomSheet,
        manager: buildManager,
        info: (context) => const Placeholder(),
        exit: exit,
        app: app,
      ),
    );
  }

  @override
  BuildContext get context {
    return super.getBuildContext();
  }

  @override
  set context(BuildContext context) {
    super.attachBuildContext(context);
  }

  /// 方法调用
  @override
  Future<dynamic> onMethodCall(
    String method, [
    dynamic arguments,
  ]) async {
    return await null;
  }

  @override
  Future<void> init(List<RuntimePlugin> plugins) async {
    return await null;
  }

  /// 获取管理器
  @override
  Widget buildManager(BuildContext context) {
    return pluginWidget(context);
  }

  /// 构建ViewModel
  @override
  ChangeNotifier buildViewModel(BuildContext context) {
    return this;
  }

  /// 管理器布局
  @override
  Widget buildLayout(BuildContext context) {
    return const Placeholder();
  }

  @override
  Future<dynamic> buildBottomSheet(
    BuildContext context,
    bool isManager,
  ) async {
    return await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (_) => Text(
        isManager.toString(),
      ),
    );
  }

  @override
  Future<dynamic> launchBottomSheet() async {
    return await buildBottomSheet(
      context,
      true,
    );
  }

  /// 打开管理器
  @protected
  @override
  Future<dynamic> launchManager() async {
    return await Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(routeManager);
  }

  /// 执行引擎方法
  @protected
  @override
  Future<dynamic> execEngine(
    String method, [
    dynamic arguments,
  ]) async {
    return await engineBridgerScope.onMethodCall(
      method,
      {'channel': engineChannel, ...?arguments},
    );
  }

  /// 执行方法
  @override
  Future<dynamic> exec(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    return await null;
  }

  @override
  Future<dynamic> exit() async {
    return await showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (context) => ExitDialog(
        exit: () => SystemNavigator.pop(),
      ),
    );
  }
}
