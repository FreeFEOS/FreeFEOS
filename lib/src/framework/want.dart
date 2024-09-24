import 'package:flutter/widgets.dart';

import 'service.dart';

class Want {
  Want({required this.classes});

  final dynamic classes;

  Service getService() {
    if (classes is Service) {
      return classes;
    } else {
      throw FlutterError('这他妈不是服务啊老弟');
    }
  }
}
