import 'package:flutter/widgets.dart';

import '../framework/context_wrapper.dart';
import 'base_wrapper.dart';

/// 上下文混入
base mixin ContextMixin on ContextWrapper implements BaseWrapper {
  /// 获取带有导航主机的上下文
  @override
  BuildContext get context {
    return super.getBuildContext();
  }

  /// 附加导航主机上下文
  @override
  void attachContext(BuildContext host) {
    super.attachBuildContext(host);
  }
}
