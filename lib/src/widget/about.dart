import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../intl/l10n.dart';
import '../utils/ui.dart';
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
        applicationName: isPackage ? 'FreeFEOS' : viewModel.getAppName,
        applicationVersion: viewModel.getAppVersion,
        applicationLegalese: isPackage
            ? 'FreeFEOS Flutter Package'
            : IntlLocalizations.of(
                context,
              ).aboutDialogTag,
        children: child?.toList(),
      ),
    );
  }
}
