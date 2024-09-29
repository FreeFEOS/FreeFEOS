import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/system_mmvm.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SystemViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Info'),
        ),
        body: Column(
          children: [
            FilledButton(
              onPressed: () {
                viewModel.openApplication();
              },
              child: const Text('app'),
            ),
            FilledButton(
              onPressed: () {
                viewModel.openManager();
              },
              child: const Text('mgr'),
            ),
            Text(viewModel.pluginNames()),
          ],
        ),
      ),
    );
  }
}
