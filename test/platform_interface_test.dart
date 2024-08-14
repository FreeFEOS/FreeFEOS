import 'package:flutter_test/flutter_test.dart';
import 'package:freefeos/src/interface/platform_interface.dart';
import 'package:freefeos/src/platform/freefeos.dart';
import 'package:freefeos/src/platform/freefeos_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFreeFEOSPlatform
    with MockPlatformInterfaceMixin
    implements FreeFEOSPlatform {
  @override
  Future<List?> getPlatformPluginList() async => List.empty();
  @override
  Future<bool?> openPlatformDialog() async => true;
  @override
  Future<bool?> closePlatformDialog() async => true;
}

void main() {
  final FreeFEOSPlatform initialPlatform = FreeFEOSPlatform.instance;

  test('$MethodChannelFreeFEOS 是默认实例.', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFreeFEOS>());
  });

  test('getPlatformPluginList', () async {
    FreeFEOSLinker linker = FreeFEOSLinker();
    FreeFEOSPlatform.instance = MockFreeFEOSPlatform();
    expect(await linker.getPlatformPluginList(), List.empty());
  });

  test('openPlatformDialog', () async {
    FreeFEOSLinker linker = FreeFEOSLinker();
    FreeFEOSPlatform.instance = MockFreeFEOSPlatform();
    expect(await linker.openPlatformDialog(), true);
  });

  test('closePlatformDialog', () async {
    FreeFEOSLinker linker = FreeFEOSLinker();
    FreeFEOSPlatform.instance = MockFreeFEOSPlatform();
    expect(await linker.closePlatformDialog(), true);
  });
}
