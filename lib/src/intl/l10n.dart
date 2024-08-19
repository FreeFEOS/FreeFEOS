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

  /// `调试菜单`
  String get debugMenuTitle {
    return Intl.message(
      '调试菜单',
      name: 'debugMenuTitle',
      desc: '',
      args: [],
    );
  }

  /// `打开管理器`
  String get debugMenuOpenManager {
    return Intl.message(
      '打开管理器',
      name: 'debugMenuOpenManager',
      desc: '',
      args: [],
    );
  }

  /// `关闭对话框`
  String get debugMenuCloseDebugMenu {
    return Intl.message(
      '关闭对话框',
      name: 'debugMenuCloseDebugMenu',
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
