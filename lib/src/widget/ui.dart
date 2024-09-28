import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:window_manager/window_manager.dart';

import '../intl/l10n.dart';
import '../type/context_attacher.dart';
import '../type/view_model_builder.dart';
import '../utils/utils.dart';
import '../values/route.dart';
import '../values/strings.dart';
import '../viewmodel/system_mmvm.dart';

class SystemUI extends StatefulWidget {
  const SystemUI({
    super.key,
    required this.viewModel,
    required this.attach,
    required this.manager,
    required this.settings,
    required this.plugin,
    required this.child,
  });

  final ViewModelBuilder viewModel;
  final ContextAttacher attach;
  final WidgetBuilder manager;
  final WidgetBuilder settings;
  final WidgetBuilder plugin;
  final Widget child;

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
        return MaterialPageRoute(
          builder: builder,
          settings: settings,
        );
      },
      home: Builder(
        builder: (context) {
          widget.attach(context);
          return Stack(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: PlatformUtil.kNoBanner
                    ? Container(
                        child: widget.child,
                      )
                    : Banner(
                        message: IntlLocalizations.of(
                          context,
                        ).bannerTitle,
                        location: BannerLocation.topStart,
                        child: widget.child,
                      ),
              ),
              Positioned(
                top: MediaQuery.paddingOf(context).top,
                height: kToolbarHeight,
                left: 0,
                right: 0,
                child: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Consumer<SystemViewModel>(
                    builder: (context, viewModel, child) => Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: PlatformUtil.kIsDesktop,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 4,
                            ),
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
                                      onTap: () async =>
                                          await viewModel.minimizeWindow(),
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
                                      onTap: () async =>
                                          await viewModel.maximizeWindow(),
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
                                      onTap: () async =>
                                          await viewModel.closeWindow(),
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
                          padding: const EdgeInsets.only(
                            left: 4,
                            right: 8,
                          ),
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
                                    onTap: () async =>
                                        await viewModel.openBottomSheet(false),
                                    onLongPress: () async =>
                                        await viewModel.openAboutDialog(false),
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
                                    onTap: () async =>
                                        await viewModel.openExitDialog(),
                                    onLongPress: () async =>
                                        await viewModel.openBottomSheet(false),
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
              ),
            ],
          );
        },
      ),
      routes: {
        routeManager: (context) {
          return Material(
            child: widget.manager(
              context,
            ),
          );
        },
        routeSettings: (context) {
          return Material(
            child: widget.settings(
              context,
            ),
          );
        },
        routePlugin: (context) {
          return Material(
            child: widget.plugin(
              context,
            ),
          );
        }
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
              assert(() {
                if (widget.viewModel(context) is! SystemViewModel) {
                  throw FlutterError(
                    IntlLocalizations.of(
                      context,
                    ).viewModelTypeError,
                  );
                }
                return true;
              }());
              return widget.viewModel(context) as SystemViewModel;
            },
            child: Stack(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints.expand(),
                  child: child,
                ),
                Positioned(
                  top: MediaQuery.paddingOf(context).top,
                  height: kToolbarHeight,
                  left: 0,
                  right: 0,
                  child: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: Consumer<SystemViewModel>(
                      builder: (context, viewModel, child) => GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onPanStart: (_) async {
                          return await viewModel.startDragging();
                        },
                        onDoubleTap: () async {
                          return await viewModel.maximizeWindow();
                        },
                      ),
                    ),
                  ),
                ),
              ],
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
