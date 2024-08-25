import 'package:flutter/foundation.dart';

bool get kNoBanner => kIsWebBrowser;
bool get kIsWebBrowser => kIsWeb || kIsWasm;
bool get kUseNative =>
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;
