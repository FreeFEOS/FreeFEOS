import 'package:flutter/material.dart';

import '../interface/system_interface.dart';
import '../plugin/plugin_runtime.dart';

/// 绑定层包装器
abstract interface class BaseWrapper {
  /// 运行时入口
  FreeFEOSInterface call();

  /// 绑定通信层插件
  RuntimePlugin get base;

  /// 平台嵌入层插件
  RuntimePlugin get embedder;

  /// 初始化
  Future<void> init(List<RuntimePlugin> plugins);

  /// 获取带有导航主机的上下文
  BuildContext get context;

  /// 附加带有导航主机的上下文
  void attachContext(BuildContext host);

  /// 用户App
  Widget get child;

  /// 导入用户App
  Future<void> includeApp(Widget app);

  /// 获取App
  Widget findApplication();

  /// 构建App
  Widget buildApplication();

  /// 获取管理器
  Widget buildManager(BuildContext context);

  /// 构建View Model
  ChangeNotifier buildViewModel(BuildContext context);

  /// 构建底部弹出菜单
  Widget buildBottomSheet(
    BuildContext context,
    bool isManager,
  );

  /// 构建退出对话框
  Widget buildExitDialog(BuildContext context);

  /// 构建应用信息界面
  Widget buildInfo(BuildContext context);

  /// 构建设置界面
  Widget buildSettings(BuildContext context);

  /// 打开对话框
  Future<dynamic> launchBottomSheet(bool isManager);

  /// 打开管理器
  Future<dynamic> launchManager();

  /// 打开应用信息
  Future<dynamic> launchInfo();

  /// 打开设置
  Future<dynamic> launchSettings();

  /// 打开退出应用对话框
  Future<dynamic> launchExitDialog();

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
