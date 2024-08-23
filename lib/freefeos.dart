/// API导出
library freefeos;

import 'src/export/export.dart';

export 'src/export/export.dart'
    show FreeFEOSPlugin, FreeFEOSOpen, FreeFEOSExec, FreeFEOSRunner
    hide FreeFEOSBase;

/// 平台插件注册
///
/// 插件注册由Flutter框架接管, 请勿手动注册.
final class FreeFEOSRegister extends FreeFEOSBase {
  const FreeFEOSRegister();

  /// 注册插件
  ///
  /// 插件注册由Flutter框架接管, 请勿手动注册.
  static void registerWith() => const FreeFEOSRegister()();
}
