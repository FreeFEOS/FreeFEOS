import 'package:flutter/material.dart';

import '../intl/l10n.dart';

class SheetMenu extends StatelessWidget {
  const SheetMenu({super.key, required this.manager});

  final VoidCallback manager;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(0),
                child: Tooltip(
                  message: IntlLocalizations.of(
                    context,
                  ).bottomSheetOpenManager,
                  child: ListTile(
                    title: Text(
                      IntlLocalizations.of(
                        context,
                      ).bottomSheetOpenManager,
                    ),
                    leading: const Icon(Icons.open_in_new),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 24.0),
                    enabled: true,
                    onTap: manager,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => Navigator.of(
                  context,
                  rootNavigator: true,
                ).pop(),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.paddingOf(context).bottom,
                  ),
                  child: Tooltip(
                    message: IntlLocalizations.of(
                      context,
                    ).bottomSheetCloseTooltip,
                    child: ListTile(
                      title: Align(
                        alignment: Alignment.center,
                        child: Text(
                          IntlLocalizations.of(
                            context,
                          ).bottomSheetCloseText,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
