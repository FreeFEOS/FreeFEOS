import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../intl/l10n.dart';
import '../viewmodel/system_view_model.dart';

class SheetMenu extends StatelessWidget {
  const SheetMenu({
    super.key,
    required this.isManager,
  });

  final bool isManager;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<SystemViewModel>(
            builder: (context, viewModel, child) => Column(
              children: [
                Tooltip(
                  message: IntlLocalizations.of(
                    context,
                  ).bottomSheetInfoTooltip,
                  child: ListTile(
                    leading: const FlutterLogo(),
                    title: Row(
                      children: [
                        Text(viewModel.getAppName),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                    subtitle: Text(viewModel.getAppVersion),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
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
                        ).bottomSheetManagerTooltip,
                        child: ListTile(
                          title: Text(
                            IntlLocalizations.of(
                              context,
                            ).bottomSheetManager,
                          ),
                          leading: const Icon(Icons.keyboard_command_key),
                          enabled: !isManager,
                          onTap: () async {
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop();
                            await viewModel.openManager();
                          },
                        ),
                      ),
                      Tooltip(
                        message: IntlLocalizations.of(
                          context,
                        ).bottomSheetInfoTooltip,
                        child: ListTile(
                          title: Text(
                            IntlLocalizations.of(
                              context,
                            ).bottomSheetInfo,
                          ),
                          leading: const Icon(Icons.info_outline),
                          onTap: () async {
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop();
                            await viewModel.openInfo();
                          },
                        ),
                      ),
                      Tooltip(
                        message: IntlLocalizations.of(
                          context,
                        ).bottomSheetSettingsTooltip,
                        child: ListTile(
                          title: Text(
                            IntlLocalizations.of(
                              context,
                            ).bottomSheetSettings,
                          ),
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
                        message: IntlLocalizations.of(
                          context,
                        ).bottomSheetExitToolTip,
                        child: ListTile(
                          title: Text(
                            IntlLocalizations.of(
                              context,
                            ).bottomSheetExit,
                          ),
                          leading: const Icon(Icons.exit_to_app),
                          onTap: () async {
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop();
                            await viewModel.openExitDialog();
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
                ).bottomSheetClose,
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
