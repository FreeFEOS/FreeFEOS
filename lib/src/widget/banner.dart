import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import '../type/app_builder.dart';
import '../type/context_attacher.dart';
import '../type/menu_launcher.dart';
import '../type/method_execer.dart';

/// 角标横幅
final class AppBanner extends StatelessWidget {
  const AppBanner({
    super.key,
    required this.app,
    required this.host,
    required this.attach,
    required this.open,
    required this.exec,
  });

  final AppBuilder app;
  final BuildContext host;
  final ContextAttacher attach;
  final MenuLauncher open;
  final MethodExecer exec;

  @override
  Widget build(BuildContext context) {
    attach.call(host);
    final child = app(
      host,
      open,
      exec,
    );
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
