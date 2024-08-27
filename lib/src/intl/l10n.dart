// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class IntlLocalizations {
  IntlLocalizations();

  static IntlLocalizations? _current;

  static IntlLocalizations get current {
    assert(_current != null,
        'No instance of IntlLocalizations was loaded. Try to initialize the IntlLocalizations delegate before accessing IntlLocalizations.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<IntlLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = IntlLocalizations();
      IntlLocalizations._current = instance;

      return instance;
    });
  }

  static IntlLocalizations of(BuildContext context) {
    final instance = IntlLocalizations.maybeOf(context);
    assert(instance != null,
        'No instance of IntlLocalizations present in the widget tree. Did you add IntlLocalizations.delegate in localizationsDelegates?');
    return instance!;
  }

  static IntlLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<IntlLocalizations>(context, IntlLocalizations);
  }

  /// `FreeFEOS`
  String get bannerTitle {
    return Intl.message(
      'FreeFEOS',
      name: 'bannerTitle',
      desc: '',
      args: [],
    );
  }

  /// `View Model 类型错误!`
  String get viewModelTypeError {
    return Intl.message(
      'View Model 类型错误!',
      name: 'viewModelTypeError',
      desc: '',
      args: [],
    );
  }

  /// `菜单`
  String get bottomSheetTooltip {
    return Intl.message(
      '菜单',
      name: 'bottomSheetTooltip',
      desc: '',
      args: [],
    );
  }

  /// `打开管理器`
  String get bottomSheetOpenManager {
    return Intl.message(
      '打开管理器',
      name: 'bottomSheetOpenManager',
      desc: '',
      args: [],
    );
  }

  /// `取消`
  String get bottomSheetCloseText {
    return Intl.message(
      '取消',
      name: 'bottomSheetCloseText',
      desc: '',
      args: [],
    );
  }

  /// `关闭对话框`
  String get bottomSheetCloseTooltip {
    return Intl.message(
      '关闭对话框',
      name: 'bottomSheetCloseTooltip',
      desc: '',
      args: [],
    );
  }

  /// `退出应用`
  String get closeDialogTitle {
    return Intl.message(
      '退出应用',
      name: 'closeDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `是否退出应用?`
  String get closeDialogMessage {
    return Intl.message(
      '是否退出应用?',
      name: 'closeDialogMessage',
      desc: '',
      args: [],
    );
  }

  /// `取消`
  String get closeDialogCancelButton {
    return Intl.message(
      '取消',
      name: 'closeDialogCancelButton',
      desc: '',
      args: [],
    );
  }

  /// `退出`
  String get closeDialogExitButton {
    return Intl.message(
      '退出',
      name: 'closeDialogExitButton',
      desc: '',
      args: [],
    );
  }

  /// `系统管理器`
  String get managerTitle {
    return Intl.message(
      '系统管理器',
      name: 'managerTitle',
      desc: '',
      args: [],
    );
  }

  /// `主页`
  String get managerDestinationHome {
    return Intl.message(
      '主页',
      name: 'managerDestinationHome',
      desc: '',
      args: [],
    );
  }

  /// `日志`
  String get managerDestinationLog {
    return Intl.message(
      '日志',
      name: 'managerDestinationLog',
      desc: '',
      args: [],
    );
  }

  /// `插件`
  String get managerDestinationPlugin {
    return Intl.message(
      '插件',
      name: 'managerDestinationPlugin',
      desc: '',
      args: [],
    );
  }

  /// `设置`
  String get managerDestinationSetting {
    return Intl.message(
      '设置',
      name: 'managerDestinationSetting',
      desc: '',
      args: [],
    );
  }

  /// `应用名称`
  String get managerHomeInfoAppName {
    return Intl.message(
      '应用名称',
      name: 'managerHomeInfoAppName',
      desc: '',
      args: [],
    );
  }

  /// `应用版本`
  String get managerHomeInfoAppVersion {
    return Intl.message(
      '应用版本',
      name: 'managerHomeInfoAppVersion',
      desc: '',
      args: [],
    );
  }

  /// `当前平台`
  String get managerHomeInfoPlatform {
    return Intl.message(
      '当前平台',
      name: 'managerHomeInfoPlatform',
      desc: '',
      args: [],
    );
  }

  /// `插件数量`
  String get managerHomeInfoPluginCount {
    return Intl.message(
      '插件数量',
      name: 'managerHomeInfoPluginCount',
      desc: '',
      args: [],
    );
  }

  /// `了解 FreeFEOS`
  String get managerHomeLearnTitle {
    return Intl.message(
      '了解 FreeFEOS',
      name: 'managerHomeLearnTitle',
      desc: '',
      args: [],
    );
  }

  /// `了解如何使用 FreeFEOS 进行开发。`
  String get managerHomeLearnDescription {
    return Intl.message(
      '了解如何使用 FreeFEOS 进行开发。',
      name: 'managerHomeLearnDescription',
      desc: '',
      args: [],
    );
  }

  /// `了解更多`
  String get managerHomeLearnTooltip {
    return Intl.message(
      '了解更多',
      name: 'managerHomeLearnTooltip',
      desc: '',
      args: [],
    );
  }

  /// `已复制到剪贴板!`
  String get managerLogCopyTips {
    return Intl.message(
      '已复制到剪贴板!',
      name: 'managerLogCopyTips',
      desc: '',
      args: [],
    );
  }

  /// `通道`
  String get managerPluginChannel {
    return Intl.message(
      '通道',
      name: 'managerPluginChannel',
      desc: '',
      args: [],
    );
  }

  /// `作者`
  String get managerPluginAuthor {
    return Intl.message(
      '作者',
      name: 'managerPluginAuthor',
      desc: '',
      args: [],
    );
  }

  /// `系统运行时`
  String get pluginTypeRuntime {
    return Intl.message(
      '系统运行时',
      name: 'pluginTypeRuntime',
      desc: '',
      args: [],
    );
  }

  /// `绑定通信层`
  String get pluginTypeBase {
    return Intl.message(
      '绑定通信层',
      name: 'pluginTypeBase',
      desc: '',
      args: [],
    );
  }

  /// `平台嵌入层`
  String get pluginTypeEmbedder {
    return Intl.message(
      '平台嵌入层',
      name: 'pluginTypeEmbedder',
      desc: '',
      args: [],
    );
  }

  /// `引擎插件`
  String get pluginTypeEngine {
    return Intl.message(
      '引擎插件',
      name: 'pluginTypeEngine',
      desc: '',
      args: [],
    );
  }

  /// `平台插件`
  String get pluginTypePlatform {
    return Intl.message(
      '平台插件',
      name: 'pluginTypePlatform',
      desc: '',
      args: [],
    );
  }

  /// `内核模块`
  String get pluginTypeKernel {
    return Intl.message(
      '内核模块',
      name: 'pluginTypeKernel',
      desc: '',
      args: [],
    );
  }

  /// `普通插件`
  String get pluginTypeFlutter {
    return Intl.message(
      '普通插件',
      name: 'pluginTypeFlutter',
      desc: '',
      args: [],
    );
  }

  /// `未知类型插件`
  String get pluginTypeUnknown {
    return Intl.message(
      '未知类型插件',
      name: 'pluginTypeUnknown',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `打开`
  String get pluginActionOpen {
    return Intl.message(
      '打开',
      name: 'pluginActionOpen',
      desc: '',
      args: [],
    );
  }

  /// `关于`
  String get pluginActionAbout {
    return Intl.message(
      '关于',
      name: 'pluginActionAbout',
      desc: '',
      args: [],
    );
  }

  /// `无界面`
  String get pluginActionNoUI {
    return Intl.message(
      '无界面',
      name: 'pluginActionNoUI',
      desc: '',
      args: [],
    );
  }

  /// `打开插件的界面`
  String get pluginTooltipOpen {
    return Intl.message(
      '打开插件的界面',
      name: 'pluginTooltipOpen',
      desc: '',
      args: [],
    );
  }

  /// `关于本框架`
  String get pluginTooltipAbout {
    return Intl.message(
      '关于本框架',
      name: 'pluginTooltipAbout',
      desc: '',
      args: [],
    );
  }

  /// `此插件没有界面`
  String get pluginTooltipNoUI {
    return Intl.message(
      '此插件没有界面',
      name: 'pluginTooltipNoUI',
      desc: '',
      args: [],
    );
  }

  /// `Powered by FreeFEOS`
  String get openPluginText {
    return Intl.message(
      'Powered by FreeFEOS',
      name: 'openPluginText',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<IntlLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<IntlLocalizations> load(Locale locale) =>
      IntlLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
