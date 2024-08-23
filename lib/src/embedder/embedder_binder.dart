import '../framework/service.dart';
import 'platform_embedder.dart';

final class EmbedderBinder extends Binder {
  EmbedderBinder({required this.embedder});

  final PlatformEmbedder embedder;

  @override
  Service get getService => embedder;
}
