import 'package:flutter/widgets.dart';

import 'base_wrapper.dart';

/// 应用混入
base mixin AppMixin implements BaseWrapper {
  /// 应用
  static late Widget _app;

  /// 获取应用
  @override
  Widget get child => _app;

  /// 导入应用
  @override
  Future<void> includeApp(Widget app) async => _app = app;
}
