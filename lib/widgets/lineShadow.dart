///
/// @file 提供像 CSS 那样的 shadow
/// 目前只有直线 shadow
///
library;

import 'package:flutter/material.dart';

enum Direction { top, bottom, left, right }

class RectClipper extends CustomClipper<Rect> {
  final Direction direction;
  final double clipOverSize;

  const RectClipper({required this.direction, this.clipOverSize = 20});

  @override
  Rect getClip(Size size) {
    switch (direction) {
      case Direction.top:
        return Rect.fromLTWH(0.0, 0.0, size.width, size.height + clipOverSize);
      case Direction.bottom:
        return Rect.fromLTWH(0.0, 0.0, size.width, size.height);

      default:
        return Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    }
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    // 如果裁剪区域没有变化，则不需要重新裁剪
    return oldClipper != this;
  }
}

class LineShadow extends StatelessWidget {
  final List<BoxShadow>? shadow;
  final Direction shadowDirection;
  final Widget child;

  List<BoxShadow> getDefaultShadow(Direction direction) {
    Map<Direction, List<double>> directionMap = {
      Direction.left: [-2, 0],
      Direction.right: [2, 0],
      Direction.bottom: [0, 2],
      Direction.top: [0, -2],
    };
    final offetArr = directionMap[direction] ?? [0, 0];
    return [
      BoxShadow(
          blurStyle: BlurStyle.outer,
          blurRadius: 20,
          spreadRadius: 1,
          offset: Offset(offetArr[0], offetArr[1]),
          color: Color.fromARGB(255, 82, 82, 84))
    ];
  }

  const LineShadow({
    super.key,
    this.shadowDirection = Direction.top,
    this.shadow,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
        clipBehavior: Clip.antiAlias,
        clipper: RectClipper(direction: shadowDirection),
        child: _renderLeftAndRight(_renderTopAndBottom(child)));
  }

  Widget _renderShadowItem(Direction direction) {
    if (direction != shadowDirection) {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }

    List<BoxShadow> usedShadow = shadow ?? getDefaultShadow(shadowDirection);

    bool isLeftAndRight =
        direction == Direction.left || direction == Direction.right;
    return Container(
      decoration:
          BoxDecoration(color: Colors.transparent, boxShadow: usedShadow),
      width: isLeftAndRight ? 1 : double.infinity,
      height: isLeftAndRight ? double.infinity : 1,
    );
  }

  Widget _renderTopAndBottom(Widget child) {
    return Column(
      children: [
        _renderShadowItem(Direction.top),
        Expanded(child: child),
        _renderShadowItem(Direction.bottom)
      ],
    );
  }

  Widget _renderLeftAndRight(Widget child) {
    return Row(
      children: [
        _renderShadowItem(Direction.left),
        Expanded(child: child),
        _renderShadowItem(Direction.right)
      ],
    );
  }
}
