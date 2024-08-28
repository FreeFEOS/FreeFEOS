import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../intl/l10n.dart';
import '../viewmodel/system_view_model.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          IntlLocalizations.of(
            context,
          ).infoTitle,
        ),
        actions: [
          Consumer<SystemViewModel>(
            builder: (context, viewModel, child) => IconButton(
              onPressed: () async => await viewModel.openSettings(),
              icon: const Icon(
                Icons.settings,
              ),
            ),
          ),
        ],
      ),
      body: Scrollbar(
        controller: _scrollController,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: ListView(
            controller: _scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Consumer<SystemViewModel>(
                  builder: (context, viewModel, child) => Column(
                    children: [
                      ListTile(
                        leading: const FlutterLogo(),
                        title: Text(viewModel.getAppName),
                        subtitle: Text(viewModel.getAppVersion),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: FilledButton(
                                  onPressed: () {},
                                  child: Text('进入应用'),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: OutlinedButton(
                                  onPressed: () {},
                                  child: Text('打开管理器'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
