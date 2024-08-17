import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../embedder/embedder_mixin.dart';
import '../engine/bridge_mixin.dart';
import '../intl/l10n.dart';
import '../plugin/plugin_runtime.dart';
import '../type/app_builder.dart';
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
import '../viewmodel/manager_view_model.dart';
import '../widget/banner.dart';
import 'base_mixin.dart';
import 'base_wrapper.dart';

base class SystemBase extends ContextWrapper
    with
        RuntimeMixin,
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
    return ChangeNotifierProvider<ManagerViewModel>(
      create: (context) {
        final viewModel = buildViewModel(context);
        assert(() {
          if (viewModel is! ManagerViewModel) {
            throw FlutterError(
              IntlLocalizations.of(
                context,
              ).viewModelTypeError,
            );
          }
          return true;
        }());
        return viewModel as ManagerViewModel;
      },
      child: buildLayout(context),
    );
  }

  /// 运行应用
  @override
  Future<void> runFreeFEOSApp(
    AppRunner runner,
    PluginList plugins,
    AppBuilder app,
    Object? error,
  ) async {
    // 初始化日志
    Log.init();
    // 打印横幅
    Log.d(
      tag: baseTag,
      message: '\n${utf8.decode(base64Decode(banner))}',
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

    // 启动应用
    return await runner(
      Builder(
        builder: (context) => Theme(
          data: ThemeData(
            useMaterial3: true,
            brightness: MediaQuery.platformBrightnessOf(
              context,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: MediaQuery.platformBrightnessOf(
                context,
              ),
            ),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
              },
            ),
          ),
          child: ToastificationWrapper(
            child: WidgetsApp(
              initialRoute: routeApp,
              pageRouteBuilder: <T>(
                RouteSettings settings,
                WidgetBuilder builder,
              ) {
                return MaterialPageRoute(
                  builder: builder,
                  settings: settings,
                );
              },
              routes: {
                routeApp: (context) {
                  return AppBanner(
                    app: app,
                    host: context,
                    wrapper: this,
                    open: buildDialog,
                    exec: exec,
                  );
                },
                routeManager: (context) {
                  return Material(
                    child: buildManager(
                      context,
                    ),
                  );
                },
              },
              title: packageName,
              color: Colors.transparent,
              locale: const Locale('zh', 'CN'),
              localizationsDelegates: const [
                IntlLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: IntlLocalizations.delegate.supportedLocales,
              debugShowCheckedModeBanner: false,
            ),
          ),
        ),
      ),
    );
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
  Future<void> init(List<RuntimePlugin> plugins) async {}

  /// 获取管理器
  @override
  Widget buildManager(BuildContext context) => pluginWidget(context);

  /// 构建ViewModel
  @override
  ChangeNotifier buildViewModel(BuildContext context) => this;

  /// 管理器布局
  @override
  Widget buildLayout(BuildContext context) => const Placeholder();

  @override
  Future<dynamic> buildDialog(
    BuildContext context, {
    bool isManager = false,
  }) async {
    return await showDialog(
      context: context,
      useRootNavigator: true,
      builder: (_) => Text(
        isManager.toString(),
      ),
    );
  }

  @override
  Future<dynamic> launchDialog() async {
    return await buildDialog(
      super.getBuildContext(),
      isManager: true,
    );
  }

  /// 打开管理器
  @protected
  @override
  Future<dynamic> launchManager() async {
    return await Navigator.of(
      super.getBuildContext(),
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
}
