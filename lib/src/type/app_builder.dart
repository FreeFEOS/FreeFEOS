import 'package:flutter/widgets.dart';

import 'menu_launcher.dart';
import 'method_execer.dart';

typedef AppBuilder = Widget Function(
  BuildContext context,
  MenuLauncher openDebugMenu,
  MethodExecer execPluginMethod,
);
