import 'package:irondash_engine_context/irondash_engine_context.dart';

import '../rust/export.dart';
import '../rust/frb_generated.dart';

/// 内核桥接混入
base mixin KernelBridgeMixin {
  late KernelBridge _kernelBridge;

  Future<void> initKernelBridge() async => _kernelBridge = KernelBridge();

  KernelBridge get kernelBridgeScope => _kernelBridge;
}

/// 内核模块
abstract class KernelModule {}

/// 内核桥接
final class KernelBridge extends KernelModule {
  /// TODO: 内核相关操作
  Future<void> onCreateKernel() async {
    final kernel = FreeFEOSKernel();
    await kernel.initHandle();
  }
}

/// 内核
final class FreeFEOSKernel extends KernelModule {
  FreeFEOSKernel() {
    RustLib.init();
  }

  Future<void> initHandle() async {
    return await nativeMethod(
      handle: await EngineContext.instance.getEngineHandle(),
    );
  }
}
