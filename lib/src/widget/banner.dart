import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../framework/context_wrapper.dart';
import '../type/app_builder.dart';
import '../type/dialog_builder.dart';
import '../type/method_execer.dart';

/// 角标横幅
final class AppBanner extends StatelessWidget {
  const AppBanner({
    super.key,
    required this.app,
    required this.host,
    required this.wrapper,
    required this.open,
    required this.exec,
  });

  final AppBuilder app;
  final BuildContext host;
  final ContextWrapper wrapper;
  final DialogBuilder open;
  final MethodExecer exec;

  @override
  Widget build(BuildContext context) {
    wrapper.attachBuildContext.call(host);
    final child = app(
      host,
      () async => await open(host),
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
