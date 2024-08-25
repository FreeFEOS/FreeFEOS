import 'menu_launcher.dart';
import 'method_execer.dart';

typedef ApiBuilder = Future<void> Function(
  MenuLauncher openDebugMenu,
  MethodExecer execPluginMethod,
);
