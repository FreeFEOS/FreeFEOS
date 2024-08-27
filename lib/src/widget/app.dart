import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../intl/l10n.dart';
import '../type/context_attacher.dart';
import '../type/view_model_builder.dart';
import '../utils/platform.dart';
import '../values/route.dart';
import '../values/strings.dart';
import '../viewmodel/manager_view_model.dart';

class FreeFEOSApp extends StatefulWidget {
  const FreeFEOSApp({
    super.key,
    required this.viewModel,
    required this.attach,
    required this.manager,
    required this.info,
    required this.settings,
    required this.child,
  });

  final ViewModelBuilder viewModel;
  final ContextAttacher attach;
  final WidgetBuilder manager;
  final WidgetBuilder info;
  final WidgetBuilder settings;
  final Widget child;

  @override
  State<FreeFEOSApp> createState() => _FreeFEOSAppState();
}

class _FreeFEOSAppState extends State<FreeFEOSApp> {
  @override
  Widget build(BuildContext context) {
    return Theme(
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
        child: ChangeNotifierProvider<ManagerViewModel>(
          create: (context) {
            assert(() {
              if (widget.viewModel(context) is! ManagerViewModel) {
                throw FlutterError(
                  IntlLocalizations.of(
                    context,
                  ).viewModelTypeError,
                );
              }
              return true;
            }());
            return widget.viewModel(context) as ManagerViewModel;
          },
          child: WidgetsApp(
            initialRoute: routeApp,
            pageRouteBuilder: <T>(
              RouteSettings settings,
              WidgetBuilder builder,
            ) {
              return MaterialPageRoute(
                builder: builder,
                settings: settings,
              );
            },
            routes: {
              routeApp: (context) {
                return AppBuilder(
                  attach: widget.attach,
                  app: widget.child,
                );
              },
              routeManager: (context) {
                return Material(
                  child: widget.manager(
                    context,
                  ),
                );
              },
              routeInfo: (context) {
                return Material(
                  child: widget.info(
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
              }
            },
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
          ),
        ),
      ),
    );
  }
}

class AppBuilder extends StatefulWidget {
  const AppBuilder({
    super.key,
    required this.attach,
    required this.app,
  });

  final ContextAttacher attach;
  final Widget app;

  @override
  State<AppBuilder> createState() => _AppBuilderState();
}

class _AppBuilderState extends State<AppBuilder> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.attach.call(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: kNoBanner
              ? widget.app
              : Banner(
                  message: IntlLocalizations.of(
                    context,
                  ).bannerTitle,
                  textDirection: TextDirection.ltr,
                  location: BannerLocation.topStart,
                  layoutDirection: TextDirection.ltr,
                  color: Colors.pink,
                  child: widget.app,
                ),
        ),
        Positioned(
          top: MediaQuery.paddingOf(context).top,
          right: 8,
          child: Container(
            alignment: Alignment.centerRight,
            height: kToolbarHeight,
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Material(
                color: Colors.transparent,
                child: Consumer<ManagerViewModel>(
                  builder: (context, viewModel, child) => Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          await viewModel.bottomSheet(false);
                        },
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 3,
                          ),
                          child: Icon(
                            Icons.more_horiz,
                            color: Colors.white,
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
                        onTap: () async {
                          await viewModel.exitDialog();
                        },
                        onLongPress: () async {
                          await viewModel.bottomSheet(false);
                        },
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 11.75,
                            vertical: 3,
                          ),
                          child: Icon(
                            Icons.adjust,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
