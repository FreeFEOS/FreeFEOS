import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/system_mmvm.dart';

class PluginUI extends StatelessWidget {
  const PluginUI({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Consumer<SystemViewModel>(
          builder: (context, viewModel, child) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: (_) async => await viewModel.startDragging(),
            onDoubleTap: () async => await viewModel.maximizeWindow(),
            child: child,
          ),
          child: AppBar(
            title: Text(title),
          ),
        ),
      ),
      body: child,
    );
  }
}
