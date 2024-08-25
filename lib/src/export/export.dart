import 'package:flutter/widgets.dart';

import '../entry/system_entry.dart';
import '../interface/platform_interface.dart';
import '../interface/system_interface.dart';
import '../platform/method_channel.dart';
import '../plugin/plugin_runtime.dart';
import '../type/app_builder.dart';
import '../type/app_runner.dart';
import '../type/menu_launcher.dart';
import '../type/method_execer.dart';
import '../type/plugin_list.dart';

/// 插件
typedef FreeFEOSPlugin = RuntimePlugin;

/// 打开调试对话框API的类型定义
///
/// 实在不明白这个类型定义的用处, 可以读一下示例程序的源码.
typedef FreeFEOSOpen = MenuLauncher;

/// 调用插件方法API的类型定义
///
/// 实在不明白这个类型定义的用处, 可以读一下示例程序的源码.
typedef FreeFEOSExec = MethodExecer;

/// 注册器基类
///
/// 此类用于通过注册器继承向Flutter框架注册此插件.
/// 插件注册由Flutter框架接管, 请勿手动注册.
/// 此类为内部方法通过导出接口时hide无法被外部访问.
///
/// 来来来, 让我看看到底是谁不信邪, 自己又注册一遍?
/// 不要问我是不是注册器继承这个类了, 不过确实是这样.
/// 那注册器是不是公开访问的? 废话! 不公开插件怎么被Flutter注册?
/// 虽然说不听老人言开心好几年, 但是你不听话确实会有不可预测的情况出现, 为了代码稳定起见还是别不信邪了.
/// 实在不信邪也可以试试, 崩了跟我可无关. ╮(╯_╰)╭
abstract base class FreeFEOSBase {
  const FreeFEOSBase();

  void call() {
    FreeFEOSInterface.instance = SystemEntry();
    FreeFEOSPlatform.instance = MethodChannelFreeFEOS();
  }
}

/// 启动应用
///
/// 需要将入口函数main的void类型改为Future<void>并添加async标签转为异步函数.
///
/// [app] 传入的是
///
/// ```dart
/// Future<void> main() async {
///   runFreeFEOSApp(
///     runner: (app) async => runApp(app),
///     plugins: () => [ExamplePlugin()],
///     app: (context, open, exec) {
///       Global.open = open;
///       Global.exec = exec;
///       return const MyApp();
///     },
///   );
/// }
/// ```
final class FreeFEOSRunner {
  /// Runner
  final AppRunner runner;

  /// 插件
  final PluginList plugins;

  /// initApi
  final ApiBuilder initApi;

  /// 单例模式
  static FreeFEOSRunner? _runner;

  FreeFEOSInterface get _entry {
    return FreeFEOSInterface.instance;
  }

  /// 工厂
  factory FreeFEOSRunner({
    required Future<void> Function(Widget app) runner,
    required List<FreeFEOSPlugin> Function() plugins,
    required Future<void> Function(
      FreeFEOSOpen open,
      FreeFEOSExec exec,
    ) initApi,
  }) {
    _runner ??= FreeFEOSRunner._(
      runner: runner,
      plugins: plugins,
      initApi: initApi,
    );
    return _runner!;
  }

  /// 构造
  const FreeFEOSRunner._({
    required this.runner,
    required this.plugins,
    required this.initApi,
  });

  Future<void> call({
    required Widget app,
  }) async {
    return await _entry.runApp(
      runner: runner,
      plugins: plugins,
      api: initApi,
      app: app,
      error: null,
    );
  }
}

/// 此文件为导出的, 可被外部访问的公共API接口, 但 [FreeFEOSBase] 类除外.
/// 有关API的完整示例代码, 请参阅 https://pub.dev/packages/freefeos/example
