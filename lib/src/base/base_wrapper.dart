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

  /// 获取管理器
  Widget buildManager(BuildContext context);

  /// 构建View Model
  ChangeNotifier buildViewModel(BuildContext context);

  /// 管理器布局
  Widget buildLayout(BuildContext context);

  /// 构建对话框
  Future<dynamic> buildDialog(
    BuildContext context,
    bool isManager,
  );

  /// 打开对话框
  Future<dynamic> launchDialog();

  /// 打开管理器
  Future<dynamic> launchManager();

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
