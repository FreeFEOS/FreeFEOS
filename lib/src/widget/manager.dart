import 'dart:collection';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../event/event_buffer.dart';
import '../event/rendered_event.dart';
import '../framework/ansi_parser.dart';
import '../framework/log.dart';
import '../framework/toast.dart';
import '../intl/l10n.dart';
import '../plugin/plugin_details.dart';
import '../viewmodel/system_mmvm.dart';
import 'settings.dart';

class SystemManager extends StatefulWidget {
  const SystemManager({super.key});

  @override
  State<SystemManager> createState() => _SystemManagerState();
}

class _SystemManagerState extends State<SystemManager> {
  /// 当前页面
  int _currentIndex = 0;

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
      smallBreakpoint: const Breakpoint(
        endWidth: 600,
      ),
      mediumBreakpoint: const Breakpoint(
        beginWidth: 600,
        endWidth: 840,
      ),
      largeBreakpoint: const Breakpoint(
        beginWidth: 840,
      ),
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
          child: Align(
            alignment: Alignment.topCenter,
            child: [
              const HomePage(),
              const LogcatPage(),
              const PluginPage(),
              const SystemSettings(
                isManager: true,
              ),
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Consumer<SystemViewModel>(
          builder: (context, viewModel, child) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: (_) async => await viewModel.startDragging(),
            onDoubleTap: () async => await viewModel.maximizeWindow(),
            child: AppBar(
              title: Text(
                IntlLocalizations.of(
                  context,
                ).managerTitle,
              ),
              actions: [
                Tooltip(
                  message: IntlLocalizations.of(
                    context,
                  ).bottomSheetTooltip,
                  child: IconButton(
                    onPressed: () async =>
                        await viewModel.openBottomSheet(true),
                    icon: const Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBarBreakpoint: Breakpoints.standard,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 840),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                child: Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        const FlutterLogo(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Consumer<SystemViewModel>(
                              builder: (context, viewModel, child) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder(
                                    future: viewModel.getAppName(),
                                    builder: (context, snapshot) {
                                      String text = IntlLocalizations.of(
                                        context,
                                      ).unknown;
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          text = IntlLocalizations.of(
                                            context,
                                          ).waiting;
                                          break;
                                        case ConnectionState.done:
                                          if (snapshot.hasError) {
                                            text = IntlLocalizations.of(
                                              context,
                                            ).error;
                                            break;
                                          }
                                          if (snapshot.hasData) {
                                            text = snapshot.data ??
                                                IntlLocalizations.of(
                                                  context,
                                                ).sNull;
                                            break;
                                          }
                                          break;
                                        default:
                                          break;
                                      }
                                      return Text(
                                        text,
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 4),
                                  FutureBuilder(
                                    future: viewModel.getAppVersion(),
                                    builder: (context, snapshot) {
                                      String text = IntlLocalizations.of(
                                        context,
                                      ).unknown;
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          text = IntlLocalizations.of(
                                            context,
                                          ).waiting;
                                          break;
                                        case ConnectionState.done:
                                          if (snapshot.hasError) {
                                            text = IntlLocalizations.of(
                                              context,
                                            ).error;
                                            break;
                                          }
                                          if (snapshot.hasData) {
                                            text = snapshot.data ??
                                                IntlLocalizations.of(
                                                  context,
                                                ).sNull;
                                            break;
                                          }
                                          break;
                                        default:
                                          break;
                                      }
                                      return Text(
                                        text,
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Consumer<SystemViewModel>(
                            builder: (context, viewModel, child) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                  future: viewModel.getAppName(),
                                  builder: (context, snapshot) {
                                    String text = IntlLocalizations.of(
                                      context,
                                    ).unknown;
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        text = IntlLocalizations.of(
                                          context,
                                        ).waiting;
                                        break;
                                      case ConnectionState.done:
                                        if (snapshot.hasError) {
                                          text = IntlLocalizations.of(
                                            context,
                                          ).error;
                                          break;
                                        }
                                        if (snapshot.hasData) {
                                          text = snapshot.data ??
                                              IntlLocalizations.of(
                                                context,
                                              ).sNull;
                                          break;
                                        }
                                        break;
                                      default:
                                        break;
                                    }
                                    return InfoItem(
                                      title: IntlLocalizations.of(
                                        context,
                                      ).managerHomeInfoAppName,
                                      subtitle: text,
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                FutureBuilder(
                                  future: viewModel.getAppVersion(),
                                  builder: (context, snapshot) {
                                    String text = IntlLocalizations.of(
                                      context,
                                    ).unknown;
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        text = IntlLocalizations.of(
                                          context,
                                        ).waiting;
                                        break;
                                      case ConnectionState.done:
                                        if (snapshot.hasError) {
                                          text = IntlLocalizations.of(
                                            context,
                                          ).error;
                                          break;
                                        }
                                        if (snapshot.hasData) {
                                          text = snapshot.data ??
                                              IntlLocalizations.of(
                                                context,
                                              ).sNull;
                                          break;
                                        }
                                        break;
                                      default:
                                        break;
                                    }
                                    return InfoItem(
                                      title: IntlLocalizations.of(
                                        context,
                                      ).managerHomeInfoAppVersion,
                                      subtitle: text,
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                InfoItem(
                                  title: IntlLocalizations.of(
                                    context,
                                  ).managerHomeInfoPlatform,
                                  subtitle: Theme.of(context).platform.name,
                                ),
                                const SizedBox(height: 16),
                                InfoItem(
                                  title: IntlLocalizations.of(
                                    context,
                                  ).managerHomeInfoPluginCount,
                                  subtitle: viewModel.pluginCount().toString(),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        await viewModel.openAboutDialog(false);
                                      },
                                      child: Text(
                                        IntlLocalizations.of(
                                          context,
                                        ).managerHomeInfoAbout,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                IntlLocalizations.of(
                                  context,
                                ).managerHomeLearnTitle,
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                IntlLocalizations.of(
                                  context,
                                ).managerHomeLearnDescription,
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Tooltip(
                          message: IntlLocalizations.of(
                            context,
                          ).managerHomeLearnTooltip,
                          child: Consumer<SystemViewModel>(
                            builder: (context, viewModel, child) => IconButton(
                              onPressed: viewModel.launchPubDev,
                              icon: Icon(
                                Icons.open_in_browser,
                                size: Theme.of(context).iconTheme.size,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

class InfoItem extends StatelessWidget {
  const InfoItem({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Text>[
        Text(
          title,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          subtitle,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class LogcatPage extends StatefulWidget {
  const LogcatPage({super.key});

  @override
  State<LogcatPage> createState() => _LogcatPageState();
}

class _LogcatPageState extends State<LogcatPage> {
  final ListQueue<RenderedEvent> _renderedBuffer = ListQueue();
  final ScrollController _scrollController = ScrollController();
  final StringBuffer _logs = StringBuffer('Start: ');
  List<RenderedEvent> _filteredBuffer = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _renderedBuffer.clear();
    for (var event in EventBuffer.outputEventBuffer) {
      final ParserWrapper parser = AnsiParser(
        context: context,
        showTips: () => Toast.makeToast(
          context: context,
          text: IntlLocalizations.of(
            context,
          ).managerLogCopyTips,
        ).show(),
      );
      final String text = event.lines.join('\n');
      int currentId = 0;
      parser.parse(text);
      _renderedBuffer.add(
        RenderedEvent(
          currentId++,
          event.level,
          TextSpan(children: parser.getSpans),
          text.toLowerCase(),
        ),
      );
    }
    setState(
      () => _filteredBuffer = _renderedBuffer.where(
        (it) {
          if (it.level.value < Level.CONFIG.value) {
            return false;
          } else {
            return true;
          }
        },
      ).toList(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logs.clear();
    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemCount: _filteredBuffer.length,
        itemBuilder: (context, index) {
          final RenderedEvent logEntry = _filteredBuffer[index];
          _logs.write("${logEntry.lowerCaseText}\n");
          return Text.rich(
            logEntry.span,
            key: Key(logEntry.id.toString()),
            style: TextStyle(
              fontSize: 14,
              color: logEntry.level.toColor(context),
            ),
          );
        },
      ),
    );
  }
}

class PluginPage extends StatefulWidget {
  const PluginPage({super.key});

  @override
  State<PluginPage> createState() => _PluginPageState();
}

class _PluginPageState extends State<PluginPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 840,
        ),
        child: Consumer<SystemViewModel>(
          builder: (context, viewModel, child) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: viewModel.getPluginDetailsList.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final PluginDetails first =
                    viewModel.getPluginDetailsList.first;
                final PluginDetails last = viewModel.getPluginDetailsList.last;
                final PluginDetails details =
                    viewModel.getPluginDetailsList[index];
                return Padding(
                  padding: EdgeInsets.only(
                    top: first == details ? 12 : 6,
                    bottom: last == details ? 12 : 6,
                    left: 12,
                    right: 12,
                  ),
                  child: PluginCard(
                    details: details,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class PluginCard extends StatelessWidget {
  const PluginCard({
    super.key,
    required this.details,
  });

  final PluginDetails details;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Consumer<SystemViewModel>(
          builder: (context, viewModel, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          details.title,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: Theme.of(
                              context,
                            ).textTheme.titleMedium?.fontSize,
                            fontFamily: Theme.of(
                              context,
                            ).textTheme.titleMedium?.fontFamily,
                            height: Theme.of(
                              context,
                            ).textTheme.bodySmall?.height,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${IntlLocalizations.of(context).managerPluginChannel}: ${details.channel}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: Theme.of(
                              context,
                            ).textTheme.bodySmall?.fontSize,
                            fontFamily: Theme.of(
                              context,
                            ).textTheme.bodySmall?.fontFamily,
                            height: Theme.of(
                              context,
                            ).textTheme.bodySmall?.height,
                          ),
                        ),
                        Text(
                          '${IntlLocalizations.of(context).managerPluginChannel}: ${details.author}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: Theme.of(
                              context,
                            ).textTheme.bodySmall?.fontSize,
                            fontFamily: Theme.of(
                              context,
                            ).textTheme.bodySmall?.fontFamily,
                            height: Theme.of(
                              context,
                            ).textTheme.bodySmall?.height,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: viewModel.getPluginIcon(details),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                details.description,
                textAlign: TextAlign.start,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.apply(
                      overflow: TextOverflow.ellipsis,
                    ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      viewModel.getPluginType(
                        context,
                        details,
                      ),
                      textAlign: TextAlign.start,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall,
                    ),
                  ),
                  Tooltip(
                    message: viewModel.getPluginTooltip(
                      context,
                      details,
                    ),
                    child: TextButton(
                      onPressed: viewModel.openPlugin(
                        context,
                        details,
                      ),
                      child: Text(
                        viewModel.getPluginAction(
                          context,
                          details,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
