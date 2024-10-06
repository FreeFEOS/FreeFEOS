import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:window_manager/window_manager.dart';

import '../intl/l10n.dart';
import '../type/types.dart';
import '../utils/utils.dart';
import '../values/route.dart';
import '../values/strings.dart';
import '../viewmodel/system_mmvm.dart';
import 'about.dart';
import 'exit.dart';
import 'manager.dart';
import 'sheet.dart';

class SystemUI extends StatefulWidget {
  const SystemUI({
    super.key,
    required this.builder,
  });

  final ViewModelBuilder builder;

  @override
  State<SystemUI> createState() => _SystemUIState();
}

class _SystemUIState extends State<SystemUI> with WindowListener {
  /// 最大化按钮的图标
  IconData _maxIcon = Icons.fullscreen;

  /// 当前页面
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowMaximize() {
    super.onWindowMaximize();
    setState(
      () => _maxIcon = Icons.fullscreen_exit,
    );
  }

  @override
  void onWindowUnmaximize() {
    super.onWindowUnmaximize();
    setState(
      () => _maxIcon = Icons.fullscreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      pageRouteBuilder: <T>(
        RouteSettings settings,
        WidgetBuilder builder,
      ) {
        return MaterialPageRoute<T>(
          builder: builder,
          settings: settings,
        );
      },
      home: Consumer<SystemViewModel>(
        builder: (context, viewModel, child) {
          viewModel.attachBuildContext(context);
          return Stack(
            children: <Positioned>[
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: ConstrainedBox(
                  constraints: const BoxConstraints.expand(),
                  child: PlatformUtil.kNoBanner
                      ? Container(
                          child: viewModel.getChild,
                        )
                      : Banner(
                          message: IntlLocalizations.of(
                            context,
                          ).bannerTitle,
                          location: BannerLocation.topStart,
                          child: viewModel.getChild,
                        ),
                ),
              ),
              Positioned(
                top: MediaQuery.paddingOf(context).top,
                height: kToolbarHeight,
                left: 0,
                right: 0,
                child: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Visibility(
                        visible: PlatformUtil.kIsDesktop,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: viewModel.minimizeWindow,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 3,
                                      ),
                                      child: Icon(
                                        Icons.minimize,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    indent: 6,
                                    endIndent: 6,
                                    width: 1,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  InkWell(
                                    onTap: viewModel.maximizeWindow,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 3,
                                      ),
                                      child: Icon(
                                        _maxIcon,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    indent: 6,
                                    endIndent: 6,
                                    width: 1,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  InkWell(
                                    onTap: viewModel.closeWindow,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 3,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black.withOpacity(0.3)
                                    : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () => showModalBottomSheet(
                                    context: context,
                                    useRootNavigator: true,
                                    builder: (context) => const SystemSheet(
                                      isManager: false,
                                    ),
                                  ),
                                  onLongPress: () => showDialog(
                                    context: context,
                                    useRootNavigator: true,
                                    builder: (context) => const SystemAbout(
                                      isPackage: false,
                                    ),
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 3,
                                    ),
                                    child: Icon(
                                      Icons.more_horiz,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  indent: 6,
                                  endIndent: 6,
                                  width: 1,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                InkWell(
                                  onTap: () => showDialog(
                                    context: context,
                                    useRootNavigator: true,
                                    builder: (context) => const SystemExit(),
                                  ),
                                  onLongPress: viewModel.exitApp,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 3,
                                    ),
                                    child: Icon(
                                      Icons.adjust,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black,
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
            ],
          );
        },
      ),
      routes: <String, WidgetBuilder>{
        routeManager: (context) {
          return AdaptiveScaffold(
            destinations: <NavigationDestination>[
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
              child: <Widget>[
                const HomePage(),
                const LogcatPage(),
                const PluginPage(),
                const SettingsPage(),
              ][_currentIndex],
            ),
            transitionDuration: const Duration(
              milliseconds: 500,
            ),
            onSelectedIndexChange: (index) => setState(
              () => _currentIndex = index,
            ),
            useDrawer: false,
            appBar: AppBar(
              title: Text(
                IntlLocalizations.of(
                  context,
                ).managerTitle,
              ),
              actions: [
                Consumer<SystemViewModel>(
                  builder: (context, viewModel, child) => Tooltip(
                    message: IntlLocalizations.of(
                      context,
                    ).bottomSheetTooltip,
                    child: IconButton(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => const SystemSheet(
                          isManager: true,
                        ),
                      ),
                      icon: const Icon(Icons.more_vert),
                    ),
                  ),
                ),
              ],
            ),
            appBarBreakpoint: Breakpoints.standard,
          );
        },
        routePlugin: (context) {
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
        },
      },
      builder: (context, child) => Theme(
        data: ThemeData(
          useMaterial3: true,
          brightness: MediaQuery.platformBrightnessOf(
            context,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: MediaQuery.platformBrightnessOf(
              context,
            ),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
              TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.linux: ZoomPageTransitionsBuilder(),
              TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.windows: ZoomPageTransitionsBuilder(),
            },
          ),
        ),
        child: ToastificationWrapper(
          child: ChangeNotifierProvider<SystemViewModel>(
            create: (context) {
              final ViewModel viewModel = widget.builder(context);
              assert(() {
                if (viewModel is! SystemViewModel) {
                  throw FlutterError(
                    IntlLocalizations.of(
                      context,
                    ).viewModelTypeError,
                  );
                }
                return true;
              }());
              return viewModel as SystemViewModel;
            },
            child: Consumer<SystemViewModel>(
              builder: (context, viewModel, child) => Stack(
                children: <Positioned>[
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: child,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: MediaQuery.paddingOf(context).top,
                    right: 0,
                    height: kToolbarHeight,
                    child: PreferredSize(
                      preferredSize: const Size.fromHeight(
                        kToolbarHeight,
                      ),
                      child: GestureDetector(
                        onPanStart: (_) => viewModel.startDragging(),
                        onDoubleTap: () => viewModel.maximizeWindow(),
                        behavior: HitTestBehavior.translucent,
                      ),
                    ),
                  ),
                ],
              ),
              child: child,
            ),
          ),
        ),
      ),
      title: packageName,
      color: Colors.transparent,
      locale: const Locale('zh', 'CN'),
      localizationsDelegates: const [
        IntlLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: IntlLocalizations.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
    );
  }
}
