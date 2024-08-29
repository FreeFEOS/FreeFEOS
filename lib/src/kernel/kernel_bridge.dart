import 'kernel_module.dart';

final class KernelBridge extends KernelModule {
  Future<void> onCreateKernel() async {
    // TODO: 内核相关操作
  }
}

base mixin KernelBridgeMixin {
  late KernelBridge _kernelBridge;

  Future<void> initKernelBridge() async => _kernelBridge = KernelBridge();

  KernelBridge get kernelBridgeScope => _kernelBridge;
}
