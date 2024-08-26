import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
    required this.open,
    required this.exit,
    required this.child,
  });

  final VoidCallback open;
  final VoidCallback exit;
  final Widget child;

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
          child: child,
        ),
        Positioned(
          top: MediaQuery.paddingOf(context).top,
          right: 5,
          child: Container(
            alignment: Alignment.centerRight,
            height: kToolbarHeight,
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Material(
                color: Colors.transparent,
                child: Row(
                  children: [
                    InkWell(
                      onTap: open,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 3.0,
                        ),
                        child: Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      indent: 4,
                      endIndent: 4,
                      width: 1.0,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    InkWell(
                      onTap: exit,
                      onLongPress: open,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 3.0,
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
