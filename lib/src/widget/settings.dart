import 'package:flutter/material.dart';

import '../intl/l10n.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.isManager});

  final bool isManager;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
      body: Scrollbar(
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          children: const [],
        ),
      ),
    );
  }
}
