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
  Future<void> onCreateKernel() async {
    // TODO: 内核相关操作
  }
}

/// 内核
final class FreeFEOSKernel extends KernelModule {
  FreeFEOSKernel() {
    RustLib.init();
  }
}
