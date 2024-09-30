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

  /// `未知`
  String get unknown {
    return Intl.message(
      '未知',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `等待`
  String get waiting {
    return Intl.message(
      '等待',
      name: 'waiting',
      desc: '',
      args: [],
    );
  }

  /// `错误`
  String get error {
    return Intl.message(
      '错误',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `空`
  String get sNull {
    return Intl.message(
      '空',
      name: 'sNull',
      desc: '',
      args: [],
    );
  }

  /// `FREEFEOS`
  String get bannerTitle {
    return Intl.message(
      'FREEFEOS',
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

  /// `管理器`
  String get bottomSheetManager {
    return Intl.message(
      '管理器',
      name: 'bottomSheetManager',
      desc: '',
      args: [],
    );
  }

  /// `打开管理器`
  String get bottomSheetManagerTooltip {
    return Intl.message(
      '打开管理器',
      name: 'bottomSheetManagerTooltip',
      desc: '',
      args: [],
    );
  }

  /// `打开关于对话框`
  String get bottomSheetAboutTooltip {
    return Intl.message(
      '打开关于对话框',
      name: 'bottomSheetAboutTooltip',
      desc: '',
      args: [],
    );
  }

  /// `设置`
  String get bottomSheetSettings {
    return Intl.message(
      '设置',
      name: 'bottomSheetSettings',
      desc: '',
      args: [],
    );
  }

  /// `打开设置`
  String get bottomSheetSettingsTooltip {
    return Intl.message(
      '打开设置',
      name: 'bottomSheetSettingsTooltip',
      desc: '',
      args: [],
    );
  }

  /// `取消`
  String get bottomSheetClose {
    return Intl.message(
      '取消',
      name: 'bottomSheetClose',
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

  /// `退出`
  String get bottomSheetExit {
    return Intl.message(
      '退出',
      name: 'bottomSheetExit',
      desc: '',
      args: [],
    );
  }

  /// `退出应用`
  String get bottomSheetExitToolTip {
    return Intl.message(
      '退出应用',
      name: 'bottomSheetExitToolTip',
      desc: '',
      args: [],
    );
  }

  /// `FreeFEOS`
  String get aboutPackageName {
    return Intl.message(
      'FreeFEOS',
      name: 'aboutPackageName',
      desc: '',
      args: [],
    );
  }

  /// `FreeFEOS Flutter Package`
  String get aboutPackageDescription {
    return Intl.message(
      'FreeFEOS Flutter Package',
      name: 'aboutPackageDescription',
      desc: '',
      args: [],
    );
  }

  /// `Powered by FreeFEOS`
  String get aboutDialogLegalese {
    return Intl.message(
      'Powered by FreeFEOS',
      name: 'aboutDialogLegalese',
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

  /// `关于`
  String get managerHomeInfoAbout {
    return Intl.message(
      '关于',
      name: 'managerHomeInfoAbout',
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
  String get managerPluginTypeRuntime {
    return Intl.message(
      '系统运行时',
      name: 'managerPluginTypeRuntime',
      desc: '',
      args: [],
    );
  }

  /// `绑定通信层`
  String get managerPluginTypeBase {
    return Intl.message(
      '绑定通信层',
      name: 'managerPluginTypeBase',
      desc: '',
      args: [],
    );
  }

  /// `平台嵌入层`
  String get managerPluginTypeEmbedder {
    return Intl.message(
      '平台嵌入层',
      name: 'managerPluginTypeEmbedder',
      desc: '',
      args: [],
    );
  }

  /// `引擎插件`
  String get managerPluginTypeEngine {
    return Intl.message(
      '引擎插件',
      name: 'managerPluginTypeEngine',
      desc: '',
      args: [],
    );
  }

  /// `平台插件`
  String get managerPluginTypePlatform {
    return Intl.message(
      '平台插件',
      name: 'managerPluginTypePlatform',
      desc: '',
      args: [],
    );
  }

  /// `内核模块`
  String get managerPluginTypeKernel {
    return Intl.message(
      '内核模块',
      name: 'managerPluginTypeKernel',
      desc: '',
      args: [],
    );
  }

  /// `普通插件`
  String get managerPluginTypeFlutter {
    return Intl.message(
      '普通插件',
      name: 'managerPluginTypeFlutter',
      desc: '',
      args: [],
    );
  }

  /// `未知类型插件`
  String get managerPluginTypeUnknown {
    return Intl.message(
      '未知类型插件',
      name: 'managerPluginTypeUnknown',
      desc: '',
      args: [],
    );
  }

  /// `打开`
  String get managerPluginActionOpen {
    return Intl.message(
      '打开',
      name: 'managerPluginActionOpen',
      desc: '',
      args: [],
    );
  }

  /// `关于`
  String get managerPluginActionAbout {
    return Intl.message(
      '关于',
      name: 'managerPluginActionAbout',
      desc: '',
      args: [],
    );
  }

  /// `无界面`
  String get managerPluginActionNoUI {
    return Intl.message(
      '无界面',
      name: 'managerPluginActionNoUI',
      desc: '',
      args: [],
    );
  }

  /// `打开插件的界面`
  String get managerPluginTooltipOpen {
    return Intl.message(
      '打开插件的界面',
      name: 'managerPluginTooltipOpen',
      desc: '',
      args: [],
    );
  }

  /// `关于本框架`
  String get managerPluginTooltipAbout {
    return Intl.message(
      '关于本框架',
      name: 'managerPluginTooltipAbout',
      desc: '',
      args: [],
    );
  }

  /// `此插件没有界面`
  String get managerPluginTooltipNoUI {
    return Intl.message(
      '此插件没有界面',
      name: 'managerPluginTooltipNoUI',
      desc: '',
      args: [],
    );
  }

  /// `应用信息`
  String get infoTitle {
    return Intl.message(
      '应用信息',
      name: 'infoTitle',
      desc: '',
      args: [],
    );
  }

  /// `设置`
  String get settingsTitle {
    return Intl.message(
      '设置',
      name: 'settingsTitle',
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
