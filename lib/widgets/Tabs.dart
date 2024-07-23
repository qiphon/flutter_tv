///
/// @file 自定义 tab ，暂时只做 tab 顶部切换的样式
/// 这个 tab 只是为测试封装组件而写，以后的组件使用 bruno 中的即可
///
library;

import 'package:flutter/material.dart';
import 'package:tv_flutter/widgets/flexWithGaps.dart';

enum TabPosition {
  top,
  left,
}

class TabItem {
  final String title;
  final IconData icon;

  const TabItem({
    required this.title,
    required this.icon,
  });
}

typedef OnTabChange = void Function(int index);

class Tabs extends StatefulWidget {
  final Widget pages;
  final int activeTab;
  final double iconSize;
  final List<TabItem> tabs;
  final Color tabActiveColor;
  final TabPosition tabPosition;
  final OnTabChange? onTabChange;

  /// tab 之间的间距
  final double tabSpace;
  final EdgeInsetsGeometry padding;

  const Tabs(
      {super.key,
      required this.pages,
      required this.tabs,
      this.onTabChange,
      this.tabSpace = 8,
      this.activeTab = 0,
      this.iconSize = 20,
      this.tabActiveColor = Colors.blue,
      this.padding = const EdgeInsets.all(16),
      this.tabPosition = TabPosition.top});

  @override
  State<StatefulWidget> createState() {
    return _TabsState();
  }
}

class _TabsState extends State<Tabs> {
  Color primaryColor = Colors.blue;

  void _onTabChange(int value) {
    if (widget.onTabChange != null) {
      widget.onTabChange!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _runderTabWithPosition(),
    );
  }

  Widget _renderText(String text, int index) {
    return Text(
        style: TextStyle(
            fontSize: 24,
            color: widget.activeTab == index ? primaryColor : null),
        text);
  }

  List<Widget> _renderTabItemInner() {
    final List<Widget> result = [];
    final itemLen = widget.tabs.length;
    for (int index = 0; index < itemLen; index++) {
      final item = widget.tabs[index];
      result.add(GestureDetector(
          onTap: () => _onTabChange(index),
          child: Flex(
            direction: widget.tabPosition == TabPosition.top
                ? Axis.vertical
                : Axis.horizontal,
            children: [
              Icon(
                  size: widget.iconSize,
                  color: widget.activeTab == index ? primaryColor : null,
                  item.icon),
              _renderText(item.title, index)
            ],
          )));
      if (index < itemLen - 1) {
        result.add(SizedBox(
          width: widget.tabSpace,
        ));
      }
    }
    return result;
  }

  Widget _renderTabItem() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 8, 16),
      child: FlexWithGaps(
        direction: widget.tabPosition == TabPosition.top
            ? Axis.horizontal
            : Axis.vertical,
        children: _renderTabItemInner(),
      ),
    );
  }

  Widget _runderTabWithPosition() {
    bool tabAtTop = widget.tabPosition == TabPosition.top;
    return Container(
        padding: widget.padding,
        child: FlexWithGaps(
          direction: tabAtTop ? Axis.vertical : Axis.horizontal,
          gap: 0,
          children: [
            Flexible(flex: 0, child: _renderTabItem()),
            widget.pages,
          ],
        ));
  }
}
