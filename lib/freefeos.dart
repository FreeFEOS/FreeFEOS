/// API导出
library freefeos;

import 'src/export/export.dart';

export 'src/export/export.dart'
    show runFreeFEOSApp, FreeFEOSPlugin
    hide registerFreeFEOS;

/// 平台插件注册
///
/// 插件注册由Flutter框架接管, 请勿手动注册.
final class FreeFEOSRegister {
  const FreeFEOSRegister();

  /// 注册插件
  ///
  /// 插件注册由Flutter框架接管, 请勿手动注册.
  static void registerWith() => registerFreeFEOS();
}
