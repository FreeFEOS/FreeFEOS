import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../intl/l10n.dart';
import '../viewmodel/manager_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 840),
        child: ListView(
          controller: _scrollController,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Icon(
                        Icons.keyboard_command_key,
                        size: Theme.of(context).iconTheme.size,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Consumer<ManagerViewModel>(
                            builder: (context, viewModel, child) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  viewModel.getAppName,
                                  textAlign: TextAlign.left,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  viewModel.getAppVersion,
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 12,
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Consumer<ManagerViewModel>(
                          builder: (context, viewModel, child) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InfoItem(
                                title: IntlLocalizations.of(
                                  context,
                                ).managerHomeInfoAppName,
                                subtitle: viewModel.getAppName,
                              ),
                              const SizedBox(height: 16),
                              InfoItem(
                                title: IntlLocalizations.of(
                                  context,
                                ).managerHomeInfoAppVersion,
                                subtitle: viewModel.getAppVersion,
                              ),
                              const SizedBox(height: 16),
                              InfoItem(
                                title: IntlLocalizations.of(
                                  context,
                                ).managerHomeInfoPlatform,
                                subtitle: Theme.of(context).platform.name,
                              ),
                              const SizedBox(height: 16),
                              InfoItem(
                                title: IntlLocalizations.of(
                                  context,
                                ).managerHomeInfoPluginCount,
                                subtitle: viewModel.pluginCount().toString(),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      IntlLocalizations.of(
                                        context,
                                      ).managerHomeInfoInfo,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              IntlLocalizations.of(
                                context,
                              ).managerHomeLearnTitle,
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              IntlLocalizations.of(
                                context,
                              ).managerHomeLearnDescription,
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Tooltip(
                        message: IntlLocalizations.of(
                          context,
                        ).managerHomeLearnTooltip,
                        child: Consumer<ManagerViewModel>(
                          builder: (context, viewModel, child) => IconButton(
                            onPressed: viewModel.launchPubDev,
                            icon: Icon(
                              Icons.open_in_browser,
                              size: Theme.of(context).iconTheme.size,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  const InfoItem({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Text>[
        Text(
          title,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          subtitle,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
