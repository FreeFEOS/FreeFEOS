import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../intl/l10n.dart';
import '../utils/widget.dart';
import '../viewmodel/system_view_model.dart';

class SystemAbout extends StatelessWidget {
  const SystemAbout({
    super.key,
    required this.isPackage,
  });

  final bool isPackage;

  @override
  Widget build(BuildContext context) {
    return Consumer<SystemViewModel>(
      builder: (context, viewModel, child) {
        return FutureBuilder(
          future: viewModel.getAppName(),
          builder: (context, snapshot) {
            String appName = IntlLocalizations.of(
              context,
            ).unknown;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                appName = IntlLocalizations.of(
                  context,
                ).waiting;
                break;
              case ConnectionState.done:
                if (snapshot.hasError) {
                  appName = IntlLocalizations.of(
                    context,
                  ).error;
                  break;
                }
                if (snapshot.hasData) {
                  appName = snapshot.data ??
                      IntlLocalizations.of(
                        context,
                      ).sNull;
                  break;
                }
                break;
              default:
                break;
            }
            return FutureBuilder(
              future: viewModel.getAppVersion(),
              builder: (context, snapshot) {
                String appVersion = IntlLocalizations.of(
                  context,
                ).unknown;
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    appVersion = IntlLocalizations.of(
                      context,
                    ).waiting;
                    break;
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      appVersion = IntlLocalizations.of(
                        context,
                      ).error;
                      break;
                    }
                    if (snapshot.hasData) {
                      appVersion = snapshot.data ??
                          IntlLocalizations.of(
                            context,
                          ).sNull;
                      break;
                    }
                    break;
                  default:
                    break;
                }
                return AboutDialog(
                  applicationName: isPackage
                      ? IntlLocalizations.of(
                          context,
                        ).aboutPackageName
                      : appName,
                  applicationVersion: appVersion,
                  applicationLegalese: isPackage
                      ? IntlLocalizations.of(
                          context,
                        ).aboutPackageDescription
                      : IntlLocalizations.of(
                          context,
                        ).aboutDialogLegalese,
                  children: child?.toList(),
                );
              },
            );
          },
        );
      },
    );
  }
}
