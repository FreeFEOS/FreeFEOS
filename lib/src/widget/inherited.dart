import 'package:flutter/widgets.dart';

import '../type/method_execer.dart';

/// 遗传接口
final class ExecutorInherited extends InheritedWidget {
  const ExecutorInherited({
    super.key,
    required this.executor,
    required super.child,
  });

  /// 执行插件方法
  final MethodExecer executor;

  @override
  bool updateShouldNotify(ExecutorInherited oldWidget) {
    return oldWidget.executor != executor;
  }
}
