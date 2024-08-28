import 'package:flutter/material.dart';

import '../plugin/plugin_details.dart';

abstract interface class ViewModelWrapper {
  /// 打开底部弹出菜单
  Future<dynamic> openBottomSheet(bool isManager);

  /// 打开应用信息
  Future<dynamic> openAboutDialog(bool isPackage);

  /// 打开退出应用对话框
  Future<dynamic> openExitDialog();

  /// 进入应用
  void openApplication();

  /// 打开管理器
  Future<dynamic> openManager();

  /// 打开设置
  Future<dynamic> openSettings();

  /// 获取应用名称
  String get getAppName;

  /// 获取应用版本
  String get getAppVersion;

  /// 统计普通插件数量
  int pluginCount();

  /// 打开PubDev
  Future<bool> launchPubDev();

  /// 获取插件列表
  List<PluginDetails> get getPluginDetailsList;

  /// 获取插件图标
  Widget getPluginIcon(PluginDetails details);

  /// 获取插件类型
  String getPluginType(
    BuildContext context,
    PluginDetails details,
  );

  /// 获取插件的动作名
  String getPluginAction(
    BuildContext context,
    PluginDetails details,
  );

  /// 获取插件的提示
  String getPluginTooltip(
    BuildContext context,
    PluginDetails details,
  );

  /// 打开卡片
  VoidCallback? openPlugin(
    BuildContext context,
    PluginDetails details,
  );
}
