import 'package:flutter/widgets.dart';

import '../framework/context_wrapper.dart';
import 'base_wrapper.dart';

base mixin ContextMixin on ContextWrapper implements BaseWrapper {
  @override
  BuildContext get context {
    return super.getBuildContext();
  }

  @override
  void attachContext(BuildContext host) {
    super.attachBuildContext(host);
  }
}
