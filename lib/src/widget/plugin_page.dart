import 'package:flutter/material.dart';
import 'package:freefeos/src/intl/l10n.dart';
import 'package:provider/provider.dart';

import '../plugin/plugin_details.dart';
import '../viewmodel/manager_view_model.dart';

class PluginPage extends StatefulWidget {
  const PluginPage({super.key});

  @override
  State<PluginPage> createState() => _PluginPageState();
}

class _PluginPageState extends State<PluginPage> {
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
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Consumer<ManagerViewModel>(
                builder: (context, viewModel, child) => ListBody(
                  children: viewModel.getPluginDetailsList
                      .map(
                        (element) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PluginCard(details: element),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PluginCard extends StatelessWidget {
  const PluginCard({
    super.key,
    required this.details,
  });

  final PluginDetails details;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        details.title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleMedium?.fontSize,
                          fontFamily: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.fontFamily,
                          height: Theme.of(context).textTheme.bodySmall?.height,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${IntlLocalizations.of(context).managerPluginChannel}: ${details.channel}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                          fontFamily:
                              Theme.of(context).textTheme.bodySmall?.fontFamily,
                          height: Theme.of(context).textTheme.bodySmall?.height,
                        ),
                      ),
                      Text(
                        '${IntlLocalizations.of(context).managerPluginChannel}: ${details.author}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                          fontFamily:
                              Theme.of(context).textTheme.bodySmall?.fontFamily,
                          height: Theme.of(context).textTheme.bodySmall?.height,
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer<ManagerViewModel>(
                  builder: (context, viewModel, child) => Container(
                    child: viewModel.getPluginIcon(details),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              details.description,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodySmall?.apply(
                    overflow: TextOverflow.ellipsis,
                  ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            const Divider(),
            Consumer<ManagerViewModel>(
              builder: (context, viewModel, child) => Row(
                children: [
                  Expanded(
                    child: Text(
                      viewModel.getPluginType(details),
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Tooltip(
                    message: viewModel.getPluginTooltip(details),
                    child: TextButton(
                      onPressed: viewModel.openPlugin(details),
                      child: Text(
                        viewModel.getPluginAction(details),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
