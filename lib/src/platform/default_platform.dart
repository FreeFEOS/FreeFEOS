import '../interface/platform_interface.dart';

final class DefaultPlatform extends FreeFEOSPlatform {
  @override
  Future<List?> getPlatformPluginList() async {
    return List.empty();
  }

  @override
  Future<bool?> closePlatformDialog() async {
    return true;
  }

  @override
  Future<bool?> openPlatformDialog() async {
    return true;
  }
}
