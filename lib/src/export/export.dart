import 'package:flutter/widgets.dart';

import '../entry/system_entry.dart';
import '../interface/platform_interface.dart';
import '../interface/system_interface.dart';
import '../platform/method_channel.dart';
import '../plugin/plugin_runtime.dart';
import '../type/api_builder.dart';
import '../type/app_runner.dart';
import '../type/method_execer.dart';
import '../type/plugin_list.dart';

/// 插件
///
/// ```dart
/// final class ExamplePlugin implements FreeFEOSPlugin {
///   ExamplePlugin();
///
///   /// "ExampleAuthor"为作者信息,替换为你自己的名字即可,通过[pluginAuthor]方法定义.
///   @override
///   String get pluginAuthor => 'ExampleAuthor';
///
///   /// "example_channel"为插件的通道,可以理解为插件的唯一标识,我们通常使用全小写英文字母加下划线的命名方式,通过[pluginChannel]方法定义.
///   @override
///   String get pluginChannel => 'example_channel';
///
///   /// "Example description"为插件的描述,通过[pluginDescription]方法定.
///   @override
///   String get pluginDescription => 'Example description';
///
///   /// "Example Plugin"为插件的名称,通过[pluginName]方法定义.
///   @override
///   String get pluginName => 'ExamplePlugin';
///
///   /// 插件的用户界面
///   @override
///   Widget pluginWidget(BuildContext context) {
///     return const Center(
///       child: Text('Hello, World!'),
///     );
///   }
///
///   /// [onMethodCall]方法为插件的方法调用.
///   @override
///   Future<dynamic> onMethodCall(
///     String method, [
///     dynamic arguments,
///   ]) async {
///     switch (method) {
///       case 'add':
///         var arg = arguments['arg'];
///         return '$arg world';
///       default:
///         return await null;
///     }
///   }
/// }
/// ```
typedef FreeFEOSPlugin = RuntimePlugin;

/// 插件代码执行器
///
/// 用于执行 [FreeFEOSPlugin] 插件代码的执行器.
///
/// 具体用法:
///
/// 1.首先编写一个应用程序全局类,
/// 编写FreeFEOSExec接口, 这里使用返回空作为容错处理.
/// 如果在接下来的初始化API出现异常将不执行插件代码返回空.
///
/// ```dart
/// class Global {
///   const Global();
///
///   ......
///
///   static FreeFEOSExec exec = (
///     String channel,
///     String method, [
///     dynamic arguments,
///   ]) async {
///     return await null;
///   };
///
///   ......
///
/// }
/// ```
///
/// 2.随后在用于启动App的FreeFEOSRunner的initApi
/// 函数中将exec参数赋值给Global.exec.
///
/// ```dart
/// final run = FreeFEOSRunner(
///   runner: (app) async => runApp(app),
///   plugins: () => [ExamplePlugin()],
///   initApi: (exec) async {
///     Global.exec = exec;
///   },
/// );
/// ```
///
/// 3.最后在代码中使用Global.exec()达到执行代码的目的.
///
/// ```dart
/// dynamic result = await Global.exec(
///   'example_channel',
///   'add',
///   {'arg': 'hello'},
/// );
/// ```
///
/// 实在不明白该如何使用的, 可以读一下示例程序的源码.
/// 在该文件最下方有示例代码链接.
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
///
/// ```dart
/// final class FreeFEOSRegister extends FreeFEOSBase {
///   const FreeFEOSRegister();
///
///   static void registerWith() {
///     const FreeFEOSRegister()();
///   }
/// }
/// ```
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
/// ```dart
/// final run = FreeFEOSRunner(
///   runner: (app) async => runApp(app),
///   plugins: () => [ExamplePlugin()],
///   initApi: (exec) async {
///     Global.exec = exec;
///   },
/// );
/// await run(app: const MyApp());
/// ```
final class FreeFEOSRunner {
  const FreeFEOSRunner._({
    required this.runner,
    required this.plugins,
    required this.initApi,
  });

  /// 运行器
  final AppRunner runner;

  /// 插件列表
  final PluginList plugins;

  /// 初始化API
  final ApiBuilder initApi;

  /// 工厂构建函数
  factory FreeFEOSRunner({
    required Future<void> Function(Widget app) runner,
    required List<FreeFEOSPlugin> Function() plugins,
    required Future<void> Function(FreeFEOSExec exec) initApi,
  }) {
    return FreeFEOSRunner._(
      runner: runner,
      plugins: plugins,
      initApi: initApi,
    );
  }

  /// 启动应用
  Future<void> call({
    required Widget app,
  }) async {
    return await FreeFEOSInterface.instance.runFreeFEOSApp(
      runner: runner,
      plugins: plugins,
      initApi: initApi,
      app: app,
      error: null,
    );
  }
}

/// 此文件为导出的, 可被外部访问的公共API接口, 但 [FreeFEOSBase] 类除外.
/// 有关API的完整示例代码, 请参阅 https://pub.dev/packages/freefeos/example
