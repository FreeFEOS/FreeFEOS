// import 'dart:io';

import 'package:flutter/foundation.dart';

// bool get kUseNative => Platform.isAndroid || Platform.isIOS;

bool get kShowBanner => kDebugMode;

bool get kIsWebBroser => kIsWeb || kIsWasm;
