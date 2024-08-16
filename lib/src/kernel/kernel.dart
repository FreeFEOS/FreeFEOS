import 'package:freefeos/src/rust/frb_generated.dart';

import 'kernel_module.dart';

final class FreeFEOSKernel extends KernelModule {
  FreeFEOSKernel() {
    RustLib.init();
  }
}
