import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:toastification/toastification.dart';

import '../framework/context_wrapper.dart';
import '../intl/l10n.dart';
import '../values/route.dart';
import '../values/strings.dart';
import 'builder.dart';

class FreeFEOSApp extends StatelessWidget {
  const FreeFEOSApp({
    super.key,
    required this.wrapper,
    required this.open,
    required this.manager,
    required this.info,
    required this.exit,
    required this.app,
  });

  final ContextWrapper wrapper;
  final Future<dynamic> Function(
    BuildContext context,
    bool isManager,
  ) open;
  final WidgetBuilder manager;
  final WidgetBuilder info;
  final Future<dynamic> Function() exit;
  final Widget app;

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
                context: context,
                attach: wrapper.attachBuildContext,
                host: wrapper.getBuildContext,
                open: open,
                exit: exit,
                app: app,
              );
            },
            routeManager: (context) {
              return Material(
                child: manager(context),
              );
            },
            routeInfo: (context) {
              return Material(
                child: info(context),
              );
            },
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
    );
  }
}
