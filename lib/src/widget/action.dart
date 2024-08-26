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
                      onTap: open,
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
                      onTap: exit,
                      onLongPress: open,
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
