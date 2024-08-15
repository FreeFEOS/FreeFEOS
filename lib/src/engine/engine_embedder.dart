import '../embedder/platform_embedder.dart';
import '../framework/want.dart';
import '../values/channel.dart';
import '../values/strings.dart';
import 'binding.dart';
import 'method_call.dart';
import 'plugin_engine.dart';
import 'result.dart';

final class EngineConnectors extends EnginePlugin {
  @override
  String get author => developerName;

  @override
  String get channel => connectChannel;

  @override
  String get description => 'EngineConnectors';

  @override
  String get title => 'EngineConnectors';

  /// 服务实例
  late PlatformEmbedder _embedder;

  @override
  Future<void> onPluginAdded(PluginBinding binding) async {
    return await super.onPluginAdded(binding).then((added) {
      final Want want = Want(classes: PlatformEmbedder());
      final EmbedderConnection connect = EmbedderConnection(
        calback: (embedder) => _embedder = embedder,
      );
      startService(want);
      bindService(want, connect);
      return added;
    });
  }

  @override
  Future<void> onPluginMethodCall(
    EngineMethodCall call,
    EngineResult result,
  ) async {
    switch (call.method) {
      case 'getPlugins':
        result.success(_embedder.getPlatformPluginList());
      case 'openDialog':
        result.success(_embedder.openPlatformDialog());
      case 'closeDialog':
        result.success(_embedder.closePlatformDialog());
      default:
        result.notImplemented();
    }
  }
}
