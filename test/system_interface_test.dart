import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freefeos/src/entry/default_entry.dart';
import 'package:freefeos/src/interface/system_interface.dart';
import 'package:freefeos/src/plugin/plugin_runtime.dart';
import 'package:freefeos/src/type/app_runner.dart';
import 'package:freefeos/src/type/plugin_list.dart';
import 'package:freefeos/src/values/strings.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFreeFEOSInterface
    with MockPlatformInterfaceMixin
    implements FreeFEOSInterface, RuntimePlugin {
  bool isInitialized = false;

  @override
  FreeFEOSInterface get interface => this;

  @override
  Future<void> runFreeFEOSApp({
    required AppRunner runner,
    required PluginList plugins,
    required Widget app,
    required dynamic error,
  }) async {
    isInitialized = true;
  }

  @override
  Future execPluginMethod(
    String channel,
    String method,
    dynamic error, [
    dynamic arguments,
  ]) async {}

  @override
  String get pluginAuthor => developerName;

  @override
  String get pluginChannel => 'system_interface_test';

  @override
  String get pluginDescription => '系统接口单元测试';

  @override
  String get pluginName => '系统接口单元测试';

  @override
  Widget pluginWidget(BuildContext context) {
    return const Placeholder();
  }

  @override
  Future onMethodCall(String method, [arguments]) async {
    return await null;
  }
}

/// 系统接口单元测试
void main() {
  final FreeFEOSInterface initialInterface = FreeFEOSInterface.instance;

  test('$DefaultEntry 是默认实例.', () {
    expect(initialInterface, isInstanceOf<DefaultEntry>());
  });

  test('runFreeFEOSApp 接口调用正常.', () async {
    MockFreeFEOSInterface fakeInterface = MockFreeFEOSInterface();
    FreeFEOSInterface.instance = fakeInterface;
    await FreeFEOSInterface.instance.runFreeFEOSApp(
      runner: (app) async => runApp(app),
      plugins: () => [fakeInterface],
      app: const Placeholder(),
      error: null,
    );
    expect(fakeInterface.isInitialized, true);
  });
}
