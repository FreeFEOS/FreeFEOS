import 'package:flutter/widgets.dart';

import 'base_wrapper.dart';

base mixin AppMixin implements BaseWrapper {
  static late Widget _app;

  @override
  Widget get child => _app;

  @override
  Future<void> includeApp(Widget app) async {
    _app = app;
  }
}
