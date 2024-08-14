import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../platform/freefeos_method_channel.dart';

abstract class FreeFEOSPlatform extends PlatformInterface {
  FreeFEOSPlatform() : super(token: _token);

  static final Object _token = Object();
  static FreeFEOSPlatform _instance = MethodChannelFreeFEOS();
  static FreeFEOSPlatform get instance => _instance;
  static set instance(FreeFEOSPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List?> getPlatformPluginList() async {
    throw UnimplementedError('未实现getPlatformPluginList()接口.');
  }

  Future<bool?> openPlatformDialog() async {
    throw UnimplementedError('未实现openPlatformDialog()接口.');
  }

  Future<bool?> closePlatformDialog() async {
    throw UnimplementedError('未实现closePlatformDialog()接口.');
  }
}
