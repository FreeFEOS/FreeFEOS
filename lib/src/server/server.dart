import '../kernel/kernel_module.dart';
import '../service/service_mixin.dart';

final class Shizuku extends KernelModule with VMServiceWrapper {}

base class ShizukuApps {}

final class ServerBridge {
  Future<void> onCreateServer() async {
    // TODO: 服务相关操作
  }
}

base mixin class ServerBridgeMixin {
  late ServerBridge _serverBridge;

  Future<void> initServerBridge() async => _serverBridge = ServerBridge();

  ServerBridge get serverBridgeScope => _serverBridge;
}
