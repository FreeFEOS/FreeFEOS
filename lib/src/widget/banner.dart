import 'package:flutter/material.dart';

import '../intl/l10n.dart';
import '../utils/platform.dart';

/// 角标横幅
class AppBanner extends StatefulWidget {
  const AppBanner({
    super.key,
    required this.app,
    required this.host,
    required this.attach,
  });

  final Widget app;
  final BuildContext host;
  final Function(BuildContext context) attach;

  @override
  State<AppBanner> createState() => _AppBannerState();
}

class _AppBannerState extends State<AppBanner> {
  /// 子组件
  late Widget child;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.attach.call(widget.host);
    child = widget.app;
  }

  @override
  Widget build(BuildContext context) {
    if (kNoBanner) return child;
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
