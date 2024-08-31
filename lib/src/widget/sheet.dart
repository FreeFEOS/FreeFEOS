import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../intl/l10n.dart';
import '../viewmodel/system_view_model.dart';

class SystemSheet extends StatelessWidget {
  const SystemSheet({
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
                  ).bottomSheetAboutTooltip,
                  child: ListTile(
                    leading: const FlutterLogo(),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    title: FutureBuilder(
                      future: viewModel.getAppName(),
                      builder: (context, snapshot) {
                        String text = IntlLocalizations.of(
                          context,
                        ).unknown;
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            text = IntlLocalizations.of(
                              context,
                            ).waiting;
                            break;
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              text = IntlLocalizations.of(
                                context,
                              ).error;
                              break;
                            }
                            if (snapshot.hasData) {
                              text = snapshot.data ??
                                  IntlLocalizations.of(
                                    context,
                                  ).sNull;
                              break;
                            }
                            break;
                          default:
                            break;
                        }
                        return Text(text);
                      },
                    ),
                    subtitle: FutureBuilder(
                      future: viewModel.getAppVersion(),
                      builder: (context, snapshot) {
                        String text = IntlLocalizations.of(
                          context,
                        ).unknown;
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            text = IntlLocalizations.of(
                              context,
                            ).waiting;
                            break;
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              text = IntlLocalizations.of(
                                context,
                              ).error;
                              break;
                            }
                            if (snapshot.hasData) {
                              text = snapshot.data ??
                                  IntlLocalizations.of(
                                    context,
                                  ).sNull;
                              break;
                            }
                            break;
                          default:
                            break;
                        }
                        return Text(text);
                      },
                    ),
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
                      await viewModel.openAboutDialog(false);
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
