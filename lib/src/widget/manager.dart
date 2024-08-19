import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:provider/provider.dart';

import '../intl/l10n.dart';
import '../viewmodel/manager_view_model.dart';
import 'home_page.dart';
import 'log_page.dart';
import 'plugin_page.dart';
import 'settings_page.dart';

class SystemManager extends StatefulWidget {
  const SystemManager({super.key});

  @override
  State<SystemManager> createState() => _SystemManagerState();
}

class _SystemManagerState extends State<SystemManager> {
  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();

  /// 当前页面
  int _currentIndex = 0;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: IntlLocalizations.of(
            context,
          ).managerDestinationHome,
          tooltip: IntlLocalizations.of(
            context,
          ).managerDestinationHome,
          enabled: true,
        ),
        NavigationDestination(
          icon: const Icon(Icons.bug_report_outlined),
          selectedIcon: const Icon(Icons.bug_report),
          label: IntlLocalizations.of(
            context,
          ).managerDestinationLog,
          tooltip: IntlLocalizations.of(
            context,
          ).managerDestinationLog,
          enabled: true,
        ),
        NavigationDestination(
          icon: const Icon(Icons.extension_outlined),
          selectedIcon: const Icon(Icons.extension),
          label: IntlLocalizations.of(
            context,
          ).managerDestinationPlugin,
          tooltip: IntlLocalizations.of(
            context,
          ).managerDestinationPlugin,
          enabled: true,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: IntlLocalizations.of(
            context,
          ).managerDestinationSetting,
          tooltip: IntlLocalizations.of(
            context,
          ).managerDestinationSetting,
          enabled: true,
        ),
      ],
      smallBreakpoint: const Breakpoint(endWidth: 600),
      mediumBreakpoint: const Breakpoint(beginWidth: 600, endWidth: 840),
      largeBreakpoint: const Breakpoint(beginWidth: 840),
      selectedIndex: _currentIndex,
      body: (context) => PageTransitionSwitcher(
        duration: const Duration(
          milliseconds: 300,
        ),
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            child: child,
          );
        },
        child: SafeArea(
          left: true,
          top: false,
          right: true,
          bottom: false,
          minimum: EdgeInsets.zero,
          maintainBottomViewPadding: true,
          child: Container(
            alignment: Alignment.topCenter,
            child: [
              const HomePage(),
              const LogPage(),
              const PluginPage(),
              const SettingsPage(),
            ][_currentIndex],
          ),
        ),
      ),
      transitionDuration: const Duration(
        milliseconds: 500,
      ),
      onSelectedIndexChange: (index) => setState(
        () => _currentIndex = index,
      ),
      useDrawer: false,
      appBar: AppBar(
        title: Text(IntlLocalizations.of(context).managerTitle),
        actions: [
          Tooltip(
            message: IntlLocalizations.of(context).debugMenuTitle,
            child: Consumer<ManagerViewModel>(
              builder: (context, viewModel, child) => IconButton(
                onPressed: viewModel.openDebugMenu,
                icon: const Icon(Icons.more_vert),
              ),
            ),
          ),
        ],
      ),
      appBarBreakpoint: Breakpoints.standard,
    );
  }
}
