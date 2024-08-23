import '../values/channel.dart';
import '../values/strings.dart';
import 'method_call.dart';
import 'result.dart';
import 'engine_mixin.dart';
import 'proxy.dart';
import 'plugin_engine.dart';

final class EngineBridge extends EnginePlugin
    with EngineMixin
    implements EngineProxy {
  /// 插件入口
  EngineBridge call() => this;

  /// 插件作者
  @override
  String get author => developerName;

  /// 插件通道
  @override
  String get channel => bridgeChannel;

  /// 插件描述
  @override
  String get description => bridgeDescription;

  /// 插件名称
  @override
  String get title => bridgeTitle;

  @override
  Future<void> onPluginMethodCall(
    EngineMethodCall call,
    EngineResult result,
  ) async {
    return await null;
  }
}
