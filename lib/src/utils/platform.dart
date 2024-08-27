import 'package:flutter/foundation.dart';

bool get kNoBanner => !kDebugMode;
bool get kIsWebBrowser => kIsWeb || kIsWasm;
bool get kUseNative =>
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;
