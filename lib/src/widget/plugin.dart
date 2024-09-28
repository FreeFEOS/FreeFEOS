import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/system_mmvm.dart';

class PluginUI extends StatelessWidget {
  const PluginUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SystemViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            viewModel.getCurrentDetails.title,
          ),
        ),
        body: viewModel.getPluginWidget(
          context,
          viewModel.getCurrentDetails,
        ),
      ),
    );
  }
}
