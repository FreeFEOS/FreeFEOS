import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../type/runner.dart';

/// 角标横幅
final class AppBanner extends StatelessWidget {
  const AppBanner({
    super.key,
    required this.app,
    required this.host,
    required this.open,
    required this.exec,
  });

  final AppBuilder app;
  final BuildContext host;
  final DebugMenuLauncher open;
  final PluginMetthodExecer exec;

  @override
  Widget build(BuildContext context) {
    final child = app(host, open, exec);
    if (!kDebugMode) return child;
    return Banner(
      message: 'FreeFEOS',
      textDirection: TextDirection.ltr,
      location: BannerLocation.topStart,
      layoutDirection: TextDirection.ltr,
      color: Colors.pink,
      child: child,
    );
  }
}
