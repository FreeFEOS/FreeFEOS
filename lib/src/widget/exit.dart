import 'package:flutter/material.dart';

import '../intl/l10n.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({super.key, required this.exit});

  final VoidCallback exit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        IntlLocalizations.of(
          context,
        ).closeDialogTitle,
      ),
      content: Text(
        IntlLocalizations.of(
          context,
        ).closeDialogMessage,
      ),
      actions: [
        Tooltip(
          message: IntlLocalizations.of(
            context,
          ).closeDialogCancelButton,
          child: TextButton(
            onPressed: () => Navigator.of(
              context,
              rootNavigator: true,
            ).pop(),
            child: Text(
              IntlLocalizations.of(
                context,
              ).closeDialogCancelButton,
            ),
          ),
        ),
        Tooltip(
          message: IntlLocalizations.of(
            context,
          ).closeDialogExitButton,
          child: TextButton(
            onPressed: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pop();
              exit.call();
            },
            child: Text(
              IntlLocalizations.of(
                context,
              ).closeDialogExitButton,
            ),
          ),
        ),
      ],
    );
  }
}
