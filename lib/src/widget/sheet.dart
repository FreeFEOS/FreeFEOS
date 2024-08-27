import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../intl/l10n.dart';
import '../viewmodel/manager_view_model.dart';

class SheetMenu extends StatelessWidget {
  const SheetMenu({
    super.key,
    required this.appName,
    required this.appVersion,
    required this.isManageer,
  });

  final String appName;
  final String appVersion;
  final bool isManageer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<ManagerViewModel>(
            builder: (context, viewModel, child) => Column(
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
                    onTap: () async {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pop();
                      await viewModel.openInfo();
                    },
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    children: [
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
                          leading: const Icon(Icons.keyboard_command_key),
                          onTap: () async {
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop();
                            await viewModel.openManager();
                          },
                          enabled: !isManageer,
                        ),
                      ),
                      Tooltip(
                        message: '打开设置',
                        child: ListTile(
                          title: const Text('设置'),
                          leading: const Icon(Icons.app_settings_alt),
                          onTap: () async {
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop();
                            await viewModel.openSettings();
                          },
                        ),
                      ),
                      Tooltip(
                        message: '退出应用',
                        child: ListTile(
                          title: const Text('退出'),
                          leading: const Icon(Icons.exit_to_app),
                          onTap: () async {
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop();
                            await viewModel.exitDialog();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
