import 'package:flutter/material.dart';

import '../intl/l10n.dart';

class SystemSettings extends StatefulWidget {
  const SystemSettings({
    super.key,
    required this.isManager,
  });

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
          : AppBar(
              title: Text(
                IntlLocalizations.of(
                  context,
                ).settingsTitle,
              ),
            ),
      body: SafeArea(
        left: true,
        top: false,
        right: true,
        bottom: false,
        minimum: EdgeInsets.zero,
        maintainBottomViewPadding: true,
        child: Align(
          alignment: Alignment.topCenter,
          child: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: widget.isManager ? EdgeInsets.zero : null,
              child: const Column(
                children: [],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
