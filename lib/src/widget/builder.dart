import 'package:flutter/material.dart';

import '../intl/l10n.dart';
import '../utils/platform.dart';

class AppBuilder extends StatefulWidget {
  const AppBuilder({
    super.key,
    required this.context,
    required this.attach,
    required this.host,
    required this.open,
    required this.exit,
    required this.app,
  });

  final BuildContext context;
  final Function(BuildContext context) attach;
  final BuildContext Function() host;
  final Future<dynamic> Function(
    BuildContext context,
    bool isManager,
  ) open;
  final Future<dynamic> Function() exit;
  final Widget app;

  @override
  State<AppBuilder> createState() => _AppBuilderState();
}

class _AppBuilderState extends State<AppBuilder> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.attach.call(widget.context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      textDirection: TextDirection.ltr,
      fit: StackFit.loose,
      clipBehavior: Clip.none,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: kNoBanner
              ? widget.app
              : Banner(
                  message: IntlLocalizations.of(
                    context,
                  ).bannerTitle,
                  textDirection: TextDirection.ltr,
                  location: BannerLocation.topStart,
                  layoutDirection: TextDirection.ltr,
                  color: Colors.pink,
                  child: widget.app,
                ),
        ),
        Positioned(
          top: MediaQuery.paddingOf(context).top,
          right: 8,
          child: Container(
            alignment: Alignment.centerRight,
            height: kToolbarHeight,
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Material(
                color: Colors.transparent,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async => await widget.open(
                        widget.host(),
                        false,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 3,
                        ),
                        child: Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      indent: 6,
                      endIndent: 6,
                      width: 1,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    InkWell(
                      onTap: () async => await widget.exit(),
                      onLongPress: () async => await widget.open(
                        widget.host(),
                        false,
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 11.75,
                          vertical: 3,
                        ),
                        child: Icon(
                          Icons.adjust,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
