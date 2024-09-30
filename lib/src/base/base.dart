import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../embedder/embedder_mixin.dart';
import '../engine/bridge_mixin.dart';
import '../framework/context.dart';
import '../kernel/kernel.dart';
import '../plugin/plugin_runtime.dart';
import '../runtime/runtime.dart';
import '../type/types.dart';
import '../utils/utils.dart';
import '../values/channel.dart';
import '../values/route.dart';
import '../values/strings.dart';
import '../values/tag.dart';
import '../framework/log.dart';
import '../interface/system_interface.dart';
import '../values/drawable.dart';
import '../server/server.dart';

// TODO: 完善注释
// TODO: WebView页面
/// 绑定层包装器
abstract interface class BaseWrapper {
  /// 运行时入口
  FreeFEOSInterface call();

  /// 初始化
  Future<void> init(List<RuntimePlugin> plugins);

  /// 绑定通信层插件
  RuntimePlugin get base;

  /// 平台嵌入层插件
  RuntimePlugin get embedder;

  /// 用户App
  Widget get child;

  /// 导入用户App
  Future<void> includeApp(Widget app);

  /// 获取带有导航主机的上下文
  BuildContext get context;

  /// 附加带有导航主机的上下文
  void attachContext(BuildContext host);

  /// 获取App
  Layout buildApplication();

  /// 构建View Model
  ChangeNotifier buildViewModel(BuildContext context);

  /// 构建App
  Layout buildSystemUI(Widget child);

  /// 构建底部弹出菜单
  Layout buildBottomSheet(
    BuildContext context,
    bool isManager,
  );

  ///  构建关于对话框
  Layout buildAboutDialog(
    BuildContext context,
    bool isPackage,
  );

  /// 构建退出对话框
  Layout buildExitDialog(BuildContext context);

  /// 获取管理器
  Layout buildManager();

  /// 构建设置界面
  Layout buildSettings();

  Layout buildPlugin();

  Layout buildInfo();

  /// 打开应用
  void launchApplication();

  /// 打开对话框
  Future<dynamic> launchBottomSheet(bool isManager);

  /// 打开应用信息
  Future<dynamic> launchAboutDiialog(bool isPackage);

  /// 打开退出应用对话框
  Future<dynamic> launchExitDialog();

  /// 打开管理器
  Future<dynamic> launchManager();

  /// 打开设置
  Future<dynamic> launchSettings();

  Future<dynamic> launchPlugin();

  Future<dynamic> launchInfo();

  /// 执行引擎插件方法
  Future<dynamic> execEngine(
    String method, [
    dynamic arguments,
  ]);

  /// 执行插件方法
  Future<dynamic> exec(
    String channel,
    String method, [
    dynamic arguments,
  ]);
}

/// 应用混入
base mixin AppMixin implements BaseWrapper {
  /// 应用
  static late Widget _app;

  /// 获取应用
  @override
  Widget get child => _app;

  /// 导入应用
  @override
  Future<void> includeApp(Widget app) async => _app = app;
}

/// 入口混入
base mixin BaseEntry implements FreeFEOSInterface {
  /// 执行接口
  @override
  FreeFEOSInterface get interface => SystemBase()();
}

/// 绑定层混入
base mixin BaseMixin implements BaseWrapper {
  /// 获取绑定层实例
  @override
  RuntimePlugin get base => SystemBase();
}

/// 上下文混入
base mixin ContextMixin on ContextWrapper implements BaseWrapper {
  /// 获取带有导航主机的上下文
  @override
  BuildContext get context {
    return super.getBuildContext();
  }

  /// 附加导航主机上下文
  @override
  void attachContext(BuildContext host) {
    super.attachBuildContext(host);
  }
}

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
    required bool enabled,
    required dynamic error,
  }) {
    // 判断是否启用框架, 如果在浏览器中运行不启用.
    return enabled && !PlatformUtil.kIsWebBrowser
        // 导入App
        ? includeApp(app).then(
            (_) async {
              try {
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
                // 初始化窗口相关
                if (PlatformUtil.kIsDesktop) {
                  await windowManager.ensureInitialized();
                  await windowManager.waitUntilReadyToShow(
                    const WindowOptions(
                      //size: Size(800, 600),
                      minimumSize: Size(600, 400),
                      center: true,
                      //backgroundColor: Colors.transparent,
                      titleBarStyle: TitleBarStyle.hidden,
                    ),
                    () async {
                      await windowManager.show();
                      await windowManager.focus();
                    },
                  );
                }
                // 调用运行器启动应用
                return await runner(buildApplication());
              } catch (_) {
                // 断言没有传入异常
                assert(error == null);
                // 重新抛出异常
                rethrow;
              }
            },
          )
        // 未启用框架时直接调用运行器启动应用
        : runner(app);
  }

  /// 初始化应用
  @override
  Future<void> init(List<RuntimePlugin> plugins) async {
    return await null;
  }

  /// 获取应用
  @override
  Layout buildApplication() {
    return getResources.getLayout(
      layout: Builder(
        builder: pluginWidget,
      ),
    );
  }

  /// 构建ViewModel
  @override
  ChangeNotifier buildViewModel(BuildContext context) {
    return this;
  }

  /// 构建应用
  @override
  Layout buildSystemUI(Widget child) {
    return getResources.getLayout(
      layout: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: child,
      ),
    );
  }

  /// 构建底部弹出菜单
  @override
  Layout buildBottomSheet(
    BuildContext context,
    bool isManager,
  ) {
    return getResources.getLayout(
      layout: Expanded(
        child: Center(
          child: ListTile(
            leading: const Icon(Icons.error_outline),
            title: Text(isManager.toString()),
          ),
        ),
      ),
    );
  }

  /// 构建关于对话框
  @override
  Layout buildAboutDialog(
    BuildContext context,
    bool isPackage,
  ) {
    return getResources.getLayout(
      layout: const AboutDialog(),
    );
  }

  /// 构建退出对话框
  @override
  Layout buildExitDialog(BuildContext context) {
    return getResources.getLayout(
      layout: const AlertDialog(
        content: Placeholder(),
      ),
    );
  }

  /// 获取管理器
  @override
  Layout buildManager() {
    return getResources.layoutPlaceholder();
  }

  /// 构建设置
  @override
  Layout buildSettings() {
    return getResources.layoutPlaceholder();
  }

  @override
  Layout buildPlugin() {
    return getResources.layoutPlaceholder();
  }

  @override
  Layout buildInfo() {
    return getResources.layoutPlaceholder();
  }

  /// 打开应用
  @protected
  @override
  void launchApplication() {
    return Navigator.of(
      context,
      rootNavigator: true,
    ).popUntil(
      ModalRoute.withName(routeRoot),
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
    ).pushNamedAndRemoveUntil(
      routeManager,
      ModalRoute.withName(
        routeRoot,
      ), // 移除所有页面历史记录
    );
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

  @override
  Future<dynamic> launchPlugin() async {
    return await Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(routePlugin);
  }

  @override
  Future launchInfo() async {
    return await Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamedAndRemoveUntil(
      routeInfo,
      ModalRoute.withName(
        routeRoot,
      ), // 移除所有页面历史记录
    );
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
