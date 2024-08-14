import '../base/base_wrapper.dart';
import '../interface/system_interface.dart';
import 'runtime.dart';

/// 运行时混入
base mixin RuntimeMixin implements BaseWrapper {
  /// 获取运行时实例
  @override
  FreeFEOSInterface call() => SystemRuntime();
}
