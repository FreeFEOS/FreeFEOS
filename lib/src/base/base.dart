import 'dart:convert';

import 'package:flutter/material.dart';

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
import 'app_mixin.dart';
import 'base_entry.dart';
import 'base_mixin.dart';
import 'base_wrapper.dart';
import 'context_mixin.dart';

base class SystemBase extends ContextWrapper
    with
        ContextMixin,
        AppMixin,
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
    return buildSystemUI(child);
  }

  /// 方法调用
  @override
  Future<dynamic> onMethodCall(
    String method, [
    dynamic arguments,
  ]) async {
    return await null;
  }

  /// 运行应用
  @protected
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
    // 初始化内核
    await kernelBridgeScope.onCreateKernel();
    // 初始化服务桥接
    await initServerBridge();
    // 初始化服务
    await serverBridgeScope.onCreateServer();
    // 初始化引擎桥接
    await initEngineBridge();
    // 初始化引擎
    await engineBridgerScope.onCreateEngine(this);
    // 初始化应用
    await init(plugins());
    // 初始化API
    await initApi(
      (
        String channel,
        String method, [
        dynamic arguments,
      ]) async {
        return await () async {
          return await exec(
            channel,
            method,
            arguments,
          );
        }();
      },
    );
    // 启动应用
    return await includeApp(app).then(
      (_) async => await runner(
        findApplication(),
      ),
    );
  }

  /// 初始化应用
  @override
  Future<void> init(List<RuntimePlugin> plugins) async {
    return await null;
  }

  /// 获取应用
  @override
  Widget findApplication() {
    return Builder(
      builder: pluginWidget,
    );
  }

  /// 构建ViewModel
  @override
  ChangeNotifier buildViewModel(BuildContext context) {
    return this;
  }

  /// 构建应用
  @override
  Widget buildSystemUI(Widget child) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: child,
    );
  }

  /// 构建底部弹出菜单
  @override
  Widget buildBottomSheet(
    BuildContext context,
    bool isManager,
  ) {
    return Expanded(
      child: Center(
        child: ListTile(
          leading: const Icon(Icons.error_outline),
          title: Text(isManager.toString()),
        ),
      ),
    );
  }

  /// 构建关于对话框
  @override
  Widget buildAboutDialog(
    BuildContext context,
    bool isPackage,
  ) {
    return const AboutDialog();
  }

  /// 构建退出对话框
  @override
  Widget buildExitDialog(BuildContext context) {
    return const AlertDialog(
      content: Placeholder(),
    );
  }

  /// 获取管理器
  @override
  Widget buildManager(BuildContext context) {
    return const Placeholder();
  }

  /// 构建设置
  @override
  Widget buildSettings(BuildContext context) {
    return const Placeholder();
  }

  /// 打开应用
  @protected
  @override
  void launchApplication() {
    return Navigator.of(
      context,
      rootNavigator: true,
    ).popUntil(
      ModalRoute.withName(routeApp),
    );
  }

  /// 打开底部弹出对话框
  @protected
  @override
  Future<dynamic> launchBottomSheet(bool isManager) async {
    return await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      builder: (context) => buildBottomSheet(
        context,
        isManager,
      ),
    );
  }

  /// 打开关于对话框
  @protected
  @override
  Future<dynamic> launchAboutDiialog(bool isPackage) async {
    return await showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) => buildAboutDialog(
        context,
        isPackage,
      ),
    );
  }

  /// 打开退出对话框
  @protected
  @override
  Future<dynamic> launchExitDialog() async {
    return await showDialog(
      context: context,
      useRootNavigator: true,
      builder: buildExitDialog,
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

  /// 打开设置
  @protected
  @override
  Future<dynamic> launchSettings() async {
    return await Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(routeSettings);
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
}
