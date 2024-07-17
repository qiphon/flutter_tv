///
/// @file 补充 column gap 属性
///
///

library;

import 'package:flutter/material.dart';

class FlexWithGaps extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final Axis direction;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final Clip clipBehavior;
  final double gap;

  const FlexWithGaps(
      {super.key,
      required this.children,
      this.direction = Axis.horizontal,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.mainAxisSize = MainAxisSize.max,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.textDirection,
      this.verticalDirection = VerticalDirection.down,
      this.textBaseline,
      this.clipBehavior = Clip.none,
      this.gap = 0});

  @override
  Widget build(BuildContext context) {
    return Flex(
        direction: direction,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        clipBehavior: clipBehavior,
        children: _renderChildrenWithGap());
  }

  List<Widget> _renderChildrenWithGap() {
    int len = children.length;
    List<Widget> res = [];
    for (int i = 0; i < len; i++) {
      res.add(children[i]);
      if (i != len - 1) {
        res.add(SizedBox(
          width: direction == Axis.horizontal ? gap : 0,
          height: direction == Axis.vertical ? gap : 0,
        ));
      }
    }
    return res;
  }
}
