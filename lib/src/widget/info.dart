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
          title: Text('Info'),
        ),
        body: Column(
          children: [
            FilledButton(
              onPressed: () {
                viewModel.openApplication();
              },
              child: Text('app'),
            ),
            FilledButton(
              onPressed: () {
                viewModel.openManager();
              },
              child: Text('mgr'),
            )
          ],
        ),
      ),
    );
  }
}
