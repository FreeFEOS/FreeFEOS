import 'package:flutter/material.dart';

import '../framework/context_wrapper.dart';
import '../intl/l10n.dart';
import '../type/app_builder.dart';
import '../type/dialog_builder.dart';
import '../type/method_execer.dart';
import '../utils/platform.dart';

/// 角标横幅
class AppBanner extends StatefulWidget {
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
  State<AppBanner> createState() => _AppBannerState();
}

class _AppBannerState extends State<AppBanner> {
  late Widget child;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.wrapper.attachBuildContext.call(
      widget.host,
    );
    child = widget.app.call(
      widget.host,
      () async => await widget.open(
        widget.host,
      ),
      widget.exec,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!kShowBanner) return child;
    return Banner(
      message: IntlLocalizations.of(
        context,
      ).bannerTitle,
      textDirection: TextDirection.ltr,
      location: BannerLocation.topStart,
      layoutDirection: TextDirection.ltr,
      color: Colors.pink,
      child: child,
    );
  }
}
