/// 平台插件注册和API导出
library freefeos;

export 'src/rust/api/simple.dart';
export 'src/rust/frb_generated.dart' show RustLib;

/// 平台插件注册
///
/// 插件注册由Flutter框架接管, 请勿手动注册.
final class FreeFEOSRegister {
  const FreeFEOSRegister();

  /// 注册插件
  ///
  /// 插件注册由Flutter框架接管, 请勿手动注册.
  static void registerWith() {}
}
