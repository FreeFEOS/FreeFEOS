import '../base/base.dart';
import '../plugin/plugin_runtime.dart';
import 'platform_embedder.dart';

base mixin EmbedderMixin implements BaseWrapper {
  @override
  RuntimePlugin get embedder => PlatformEmbedder();
}
