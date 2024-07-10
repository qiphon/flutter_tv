/**
/// @file 提供像 CSS 那样的 shadow
/// 目前只有直线 shadow
 */

import 'dart:developer';

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
  final List<BoxShadow> shadow;
  final Direction shadowDirection;
  final Widget child;

  static const List<BoxShadow> defaultShadow = [
    BoxShadow(
        blurStyle: BlurStyle.outer,
        blurRadius: 10,
        spreadRadius: 1,
        offset: Offset(0, -1),
        color: Color.fromRGBO(232, 40, 40, 1))
  ];

  const LineShadow(
      {super.key,
      this.shadow = defaultShadow,
      required this.child,
      this.shadowDirection = Direction.top});

  @override
  Widget build(BuildContext context) {
    log('line shadow build');
    return ClipRect(
        clipBehavior: Clip.antiAlias,
        clipper: RectClipper(direction: shadowDirection),
        child: _renderLeftAndRight(_renderTopAndBottom(child)));
  }

  Widget _renderShadowItem() {
    bool isLeftAndRight =
        shadowDirection == Direction.left || shadowDirection == Direction.right;
    return Container(
      decoration: BoxDecoration(color: Colors.transparent, boxShadow: shadow),
      width: isLeftAndRight ? 1 : double.infinity,
      height: isLeftAndRight ? double.infinity : 1,
    );
  }

  Widget _renderTopAndBottom(Widget child) {
    return Column(
      children: [_renderShadowItem(), child, _renderShadowItem()],
    );
  }

  Widget _renderLeftAndRight(Widget child) {
    return Row(
      children: [_renderShadowItem(), child, _renderShadowItem()],
    );
  }
}
