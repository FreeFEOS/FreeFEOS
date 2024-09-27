import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../intl/l10n.dart';
import '../viewmodel/system_mmvm.dart';

class SystemSettings extends StatefulWidget {
  const SystemSettings({super.key, required this.isManager});

  final bool isManager;

  @override
  State<SystemSettings> createState() => _SystemSettingsState();
}

class _SystemSettingsState extends State<SystemSettings> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isManager
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Consumer<SystemViewModel>(
                builder: (context, viewModel, child) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: (_) async => await viewModel.startDragging(),
                  onDoubleTap: () async => await viewModel.maximizeWindow(),
                  child: child,
                ),
                child: AppBar(
                  title: Text(
                    IntlLocalizations.of(
                      context,
                    ).settingsTitle,
                  ),
                ),
              ),
            ),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: widget.isManager ? EdgeInsets.zero : null,
          child: const Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
