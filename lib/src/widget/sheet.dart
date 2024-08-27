import 'package:flutter/material.dart';

import '../intl/l10n.dart';

class SheetMenu extends StatelessWidget {
  const SheetMenu({
    super.key,
    required this.isManageer,
    required this.manager,
    required this.info,
    required this.settings,
    required this.exit,
    required this.appName,
    required this.appVersion,
  });

  final bool isManageer;
  final VoidCallback manager;
  final VoidCallback info;
  final VoidCallback settings;
  final VoidCallback exit;

  final String appName;
  final String appVersion;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Tooltip(
                message: '应用信息',
                child: ListTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  leading: const FlutterLogo(),
                  title: Row(
                    children: [
                      Text(appName),
                      const Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                  subtitle: Text(appVersion),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    info.call();
                  },
                ),
              ),
              const Divider(height: 1),
              Tooltip(
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
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    manager.call();
                  },
                  enabled: !isManageer,
                ),
              ),
              Tooltip(
                message: '打开设置',
                child: ListTile(
                  title: const Text('设置'),
                  leading: const Icon(Icons.app_settings_alt),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    settings.call();
                  },
                ),
              ),
              Tooltip(
                message: '退出应用',
                child: ListTile(
                  title: const Text('退出'),
                  leading: const Icon(Icons.exit_to_app),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    exit.call();
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Tooltip(
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            contentPadding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(context).bottom,
            ),
            onTap: () => Navigator.of(
              context,
              rootNavigator: true,
            ).pop(),
          ),
        ),
      ],
    );
  }
}
