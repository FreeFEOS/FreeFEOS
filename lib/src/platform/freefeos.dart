import '../interface/platform_interface.dart';

final class FreeFEOSLinker implements FreeFEOSPlatform {
  /// 平台实例
  final FreeFEOSPlatform _platform = FreeFEOSPlatform.instance;

  @override
  Future<bool?> closePlatformDialog() async {
    return await _platform.closePlatformDialog();
  }

  @override
  Future<List?> getPlatformPluginList() async {
    return await _platform.getPlatformPluginList();
  }

  @override
  Future<bool?> openPlatformDialog() async {
    return await _platform.openPlatformDialog();
  }
}
