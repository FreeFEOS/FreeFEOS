import 'package:flutter/material.dart';
import 'package:freefeos/src/intl/l10n.dart';
import 'package:provider/provider.dart';

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
      builder: (context, viewModel, child) => AboutDialog(
        applicationName: viewModel.getAppName,
        applicationVersion: viewModel.getAppVersion,
        applicationLegalese: IntlLocalizations.of(
          context,
        ).aboutDialogTag,
      ),
    );
  }
}
