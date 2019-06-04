import 'package:flutter/material.dart';

class AnimatedTextSwitcher extends StatelessWidget {
  const AnimatedTextSwitcher({Key key, this.child, this.alignment}) : super(key: key);

  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeInQuint,
      layoutBuilder: (currentChild, previousChildren) {
        List<Widget> children = previousChildren;
        if (currentChild != null)
          children = children.toList()..add(currentChild);
        return Stack(
          children: children,
          alignment: alignment,
        );
      },
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            alignment: alignment,
            scale: animation,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
