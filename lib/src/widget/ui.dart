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
import '../viewmodel/system_view_model.dart';

class SystemUI extends StatefulWidget {
  const SystemUI({
    super.key,
    required this.viewModel,
    required this.attach,
    required this.manager,
    required this.settings,
    required this.child,
  });

  final ViewModelBuilder viewModel;
  final ContextAttacher attach;
  final WidgetBuilder manager;
  final WidgetBuilder settings;
  final Widget child;

  @override
  State<SystemUI> createState() => _SystemUIState();
}

class _SystemUIState extends State<SystemUI> {
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
                widget.attach(context);
                return AppOverlay(
                  child: widget.child,
                );
              },
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

class AppOverlay extends StatelessWidget {
  const AppOverlay({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: kNoBanner
              ? child
              : Banner(
                  message: IntlLocalizations.of(
                    context,
                  ).bannerTitle,
                  textDirection: TextDirection.ltr,
                  location: BannerLocation.topStart,
                  layoutDirection: TextDirection.ltr,
                  color: Theme.of(context).colorScheme.primary,
                  child: child,
                ),
        ),
        Positioned(
          top: MediaQuery.paddingOf(context).top,
          height: kToolbarHeight,
          right: 8,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withOpacity(0.3)
                    : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Material(
                color: Colors.transparent,
                child: Consumer<SystemViewModel>(
                  builder: (context, viewModel, child) => Row(
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
                            color:
                                Theme.of(context).brightness == Brightness.light
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
                        onTap: () async => await viewModel.openExitDialog(),
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
                            color:
                                Theme.of(context).brightness == Brightness.light
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
        ),
      ],
    );
  }
}
