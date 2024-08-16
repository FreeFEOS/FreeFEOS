import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';

class Toast {
  const Toast({
    required this.context,
    required this.text,
  });

  final BuildContext context;
  final String text;

  factory Toast.makeToast({
    required BuildContext context,
    required String text,
  }) {
    return Toast(
      context: context,
      text: text,
    );
  }

  void show() {
    toastification.show(
      context: context,
      title: Text(text),
    );
  }
}
