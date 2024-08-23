import '../framework/service.dart';
import 'embedder_binder.dart';
import 'platform_embedder.dart';

final class EmbedderConnection implements ServiceConnection {
  EmbedderConnection({required this.calback});

  final void Function(PlatformEmbedder embedder) calback;

  @override
  void onServiceConnected(String name, IBinder service) {
    EmbedderBinder binder = service as EmbedderBinder;
    calback.call(binder.getService as PlatformEmbedder);
  }

  @override
  void onServiceDisconnected(String name) {}
}
