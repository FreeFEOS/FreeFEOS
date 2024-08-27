import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/system_view_model.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('应用信息'),
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
      body: Column(
        children: [],
      ),
    );
  }
}
