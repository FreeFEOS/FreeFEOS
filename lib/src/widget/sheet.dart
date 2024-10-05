import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../intl/l10n.dart';
import '../values/route.dart';
import '../viewmodel/system_mmvm.dart';
import 'about.dart';
import 'exit.dart';

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
                    ListTile(
                      leading: const FlutterLogo(),
                      trailing: Tooltip(
                        message: IntlLocalizations.of(
                          context,
                        ).bottomSheetAboutTooltip,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop();
                            showDialog(
                              context: context,
                              builder: (context) => SystemAbout(
                                isPackage: false,
                              ),
                            );
                          },
                          icon: const Icon(Icons.keyboard_arrow_right),
                        ),
                      ),
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
                    const Divider(
                      height: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 16,
                        bottom: 6,
                        right: 20,
                      ),
                      child: Wrap(
                        children: [
                          SheetButton(
                            onTap: () {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pop();
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushNamed(routeManager);
                            },
                            icon: Icons.manage_accounts_outlined,
                            label: IntlLocalizations.of(
                              context,
                            ).bottomSheetManager,
                            tooltip: IntlLocalizations.of(
                              context,
                            ).bottomSheetManagerTooltip,
                            enabled: !isManager,
                          ),
                          // SheetButton(
                          //   onTap: () async {
                          //     Navigator.of(
                          //       context,
                          //       rootNavigator: true,
                          //     ).pop();
                          //     Navigator.of(
                          //       context,
                          //       rootNavigator: true,
                          //     ).pushNamed(routeSettings);
                          //   },
                          //   icon: Icons.settings_outlined,
                          //   label: IntlLocalizations.of(
                          //     context,
                          //   ).bottomSheetSettings,
                          //   tooltip: IntlLocalizations.of(
                          //     context,
                          //   ).bottomSheetSettingsTooltip,
                          //   enabled: true,
                          // ),
                          // SheetButton(
                          //   onTap: () async {
                          //     Navigator.of(
                          //       context,
                          //       rootNavigator: true,
                          //     ).pop();
                          //     Navigator.of(
                          //       context,
                          //       rootNavigator: true,
                          //     ).pushNamed(routeInfo);
                          //   },
                          //   icon: Icons.info_outline,
                          //   label: '应用信息',
                          //   tooltip: '应用信息',
                          //   enabled: true,
                          // ),
                          SheetButton(
                            onTap: () async {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pop();
                            },
                            icon: Icons.link,
                            label: '官网',
                            tooltip: '官网',
                            enabled: true,
                          ),
                          SheetButton(
                            onTap: () async {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pop();
                            },
                            icon: Icons.feedback_outlined,
                            label: '反馈',
                            tooltip: '反馈',
                            enabled: true,
                          ),
                          SheetButton(
                            onTap: () {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pop();
                              showDialog(
                                context: context,
                                useRootNavigator: true,
                                builder: (context) => const SystemExit(),
                              );
                            },
                            icon: Icons.exit_to_app,
                            label: IntlLocalizations.of(
                              context,
                            ).bottomSheetExit,
                            tooltip: IntlLocalizations.of(
                              context,
                            ).bottomSheetExitToolTip,
                            enabled: true,
                          ),
                          // SheetButton(
                          //   onTap: () async {
                          //     Navigator.of(
                          //       context,
                          //       rootNavigator: true,
                          //     ).pop();
                          //   },
                          //   icon: Icons.close,
                          //   label: '取消',
                          //   tooltip: '取消',
                          //   enabled: true,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Divider(
          height: 1,
        ),
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
