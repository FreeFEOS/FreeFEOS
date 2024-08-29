import '../interface/system_interface.dart';
import 'base.dart';

/// 入口混入
base mixin BaseEntry implements FreeFEOSInterface {
  /// 执行接口
  @override
  FreeFEOSInterface get interface => SystemBase()();
}
