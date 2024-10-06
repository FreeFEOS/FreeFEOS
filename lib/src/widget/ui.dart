import 'package:flutter/material.dart';
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
import 'plugin.dart';
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
  IconData maxIcon = Icons.fullscreen;

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
      () => maxIcon = Icons.fullscreen_exit,
    );
  }

  @override
  void onWindowUnmaximize() {
    super.onWindowUnmaximize();
    setState(
      () => maxIcon = Icons.fullscreen,
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
            children: [
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
                    children: [
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
                                children: [
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
                                        maxIcon,
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
      routes: {
        routeManager: (context) {
          return const Material(
            child: SystemManager(),
          );
        },
        routePlugin: (context) {
          return const Material(
            child: PluginUI(),
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
                children: [
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
