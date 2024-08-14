import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freefeos/src/entry/default_entry.dart';
import 'package:freefeos/src/interface/system_interface.dart';
import 'package:freefeos/src/type/runner.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFreeFEOSInterface
    with MockPlatformInterfaceMixin
    implements FreeFEOSInterface {
  bool isInitialized = false;

  @override
  Future<void> runFreeFEOSApp(
    AppRunner runner,
    PluginList plugins,
    AppBuilder app,
    Object? error,
  ) async {
    isInitialized = true;
  }
}

void main() {
  final FreeFEOSInterface initialInterface = FreeFEOSInterface.instance;

  test('$DefaultEntry 是默认实例.', () {
    expect(initialInterface, isInstanceOf<DefaultEntry>());
  });

  test('runFreeFEOSApp 接口调用正常.', () async {
    MockFreeFEOSInterface fakeInterface = MockFreeFEOSInterface();
    FreeFEOSInterface.instance = fakeInterface;
    await FreeFEOSInterface.instance.runFreeFEOSApp(
      (_) async => {},
      () => const [],
      (_, __, ___) => const Placeholder(),
      null,
    );
    expect(fakeInterface.isInitialized, true);
  });
}
