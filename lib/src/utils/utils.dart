import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../framework/context.dart';

/// 平台工具集
final class PlatformUtil {
  /// 无角标
  static bool get kNoBanner => !kDebugMode;

  /// 是否在浏览器中
  static bool get kIsWebBrowser => kIsWeb || kIsWasm;

  /// 是否有原生实现的平台潜入层
  static bool get kUseNative =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  /// 是否为桌面平台
  static bool get kIsDesktop =>
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS;
}

/// 心灵鸡汤
class PoemUtil {
  /// 随机抽取一句
  String get getPoem => _list[Random().nextInt(_list.length)];

  /// 鸡汤
  static const List<String> _list = [
    '不向焦虑与抑郁投降，这个世界终会有我们存在的地方。',
    '把喜欢的一切留在身边，这便是努力的意义。',
    '治愈、温暖，这就是我们最终幸福的结局。',
    '我有一个梦，也许有一天，灿烂的阳光能照进黑暗森林。',
    '如果必须要失去，那么不如一开始就不曾拥有。',
    '我们的终点就是与幸福同在。',
    '孤独的人不会伤害别人，只会不断地伤害自己罢了。',
    '如果你能记住我的名字，如果你们都能记住我的名字，也许我或者我们，终有一天能自由地生存着。',
    '对于所有生命来说，不会死亡的绝望，是最可怕的审判。',
    '我不曾活着，又何必害怕死亡。',
  ];
}

///  Widget工具集
final class WidgetUtil {
  /// Widget转Widget列表
  static List<Widget> widget2WidgetList(Widget? child) {
    return <Container>[Container(child: child)];
  }

  /// Layout转Widget
  static Widget layout2Widget(Layout layout) {
    return LayoutFrame(layout: layout);
  }
}
