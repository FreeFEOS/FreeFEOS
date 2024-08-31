/// Web插件注册
library freefeos_web;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'src/export/export.dart';

/// 平台插件注册
///
/// 插件注册由Flutter框架接管, 请勿手动注册.
final class FreeFEOSRegister extends FreeFEOSBase {
  const FreeFEOSRegister();

  /// 注册插件
  ///
  /// 插件注册由Flutter框架接管, 请勿手动注册.
  static void registerWith(Registrar _) {
    const FreeFEOSRegister()(web: true);
  }
}
