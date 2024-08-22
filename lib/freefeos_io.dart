/// 平台插件注册
library freefeos_io;

import 'src/export/export.dart';

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
