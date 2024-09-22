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
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Consumer<SystemViewModel>(
            builder: (context, viewModel, child) => ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              child: SingleChildScrollView(
                child: Column(
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
                        subtitle: const Text('这是开发者的名字'),
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
                    Tooltip(
                      message: '',
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 16,
                                left: 16,
                                right: 24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FutureBuilder(
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
                                      return Text(
                                        text,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      );
                                    },
                                  ),
                                  Text(
                                    '这里是应用的介绍文字',
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  top: 16,
                                  bottom: 6,
                                  right: 20,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SheetButton(
                                      onTap: () async {
                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pop();
                                        await viewModel.openManager();
                                      },
                                      icon: Icons.keyboard_command_key,
                                      label: IntlLocalizations.of(
                                        context,
                                      ).bottomSheetManager,
                                      tooltip: IntlLocalizations.of(
                                        context,
                                      ).bottomSheetManagerTooltip,
                                      enabled: !isManager,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  top: 6,
                                  bottom: 16,
                                  right: 20,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SheetButton(
                                      onTap: () async {
                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pop();
                                        await viewModel.openSettings();
                                      },
                                      icon: Icons.settings,
                                      label: IntlLocalizations.of(
                                        context,
                                      ).bottomSheetSettings,
                                      tooltip: IntlLocalizations.of(
                                        context,
                                      ).bottomSheetSettingsTooltip,
                                      enabled: true,
                                    ),
                                    SheetButton(
                                      onTap: () async {
                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pop();
                                        await viewModel.openExitDialog();
                                      },
                                      icon: Icons.close,
                                      label: IntlLocalizations.of(
                                        context,
                                      ).bottomSheetExit,
                                      tooltip: IntlLocalizations.of(
                                        context,
                                      ).bottomSheetExitToolTip,
                                      enabled: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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

class SheetButton extends StatelessWidget {
  const SheetButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.enabled,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final String tooltip;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            child: Tooltip(
              message: tooltip,
              child: InkWell(
                onTap: enabled ? onTap : null,
                canRequestFocus: enabled,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12.0),
                ),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Center(
                    child: Opacity(
                      opacity: enabled ? 1 : 0.5,
                      child: Icon(
                        icon,
                        size: Theme.of(context).iconTheme.size,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Opacity(
              opacity: enabled ? 1 : 0.5,
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
