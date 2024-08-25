import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../intl/l10n.dart';
import '../viewmodel/manager_view_model.dart';

class ManagerProvider extends StatelessWidget {
  const ManagerProvider({
    super.key,
    required this.viewModel,
    required this.layout,
  });

  final ChangeNotifier viewModel;
  final Widget layout;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ManagerViewModel>(
      create: (context) {
        assert(() {
          if (viewModel is! ManagerViewModel) {
            throw FlutterError(
              IntlLocalizations.of(
                context,
              ).viewModelTypeError,
            );
          }
          return true;
        }());
        return viewModel as ManagerViewModel;
      },
      child: layout,
    );
  }
}
