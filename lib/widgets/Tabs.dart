///
/// @file 自定义 tab ，暂时只做 tab 顶部切换的样式
///
///
library;

import 'package:flutter/material.dart';

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
  int _currentTab = 0;
  Color primaryColor = Colors.blue;

  // dart 无法监听父级数据变化同步到当前值
  // @override
  // void didUpdateWidget(covariant Tabs oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   super.didUpdateWidget(oldWidget);
  //   // if (widget.activeTab != _currentTab) {
  //   // _onTabChange(widget.activeTab);
  //   // }
  // }

  void _onTabChange(int value) {
    if (widget.onTabChange != null) {
      widget.onTabChange!(value);
    }
    setState(() {
      _currentTab = value;
    });
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
            fontSize: 24, color: _currentTab == index ? primaryColor : null),
        text);
  }

  List<Widget> _renderTabItemInner() {
    final List<Widget> result = [];
    final itemLen = widget.tabs.length;
    for (int index = 0; index < itemLen; index++) {
      final item = widget.tabs[index];
      result.add(Container(
          child: GestureDetector(
              onTap: () => _onTabChange(index),
              child: Flex(
                direction: widget.tabPosition == TabPosition.top
                    ? Axis.vertical
                    : Axis.horizontal,
                children: [
                  Icon(
                      size: widget.iconSize,
                      color: _currentTab == index ? primaryColor : null,
                      item.icon),
                  _renderText(item.title, index)
                ],
              ))));
      if (index < itemLen - 1) {
        result.add(SizedBox(
          width: widget.tabSpace,
        ));
      }
    }
    return result;
  }

  Widget _renderTabItem() {
    if (widget.tabPosition == TabPosition.top) {
      return Row(children: _renderTabItemInner());
    }
    return Column(children: [
      Container(
        child: Column(children: _renderTabItemInner()),
      )
    ]);
  }

  Widget _runderTabWithPosition() {
    bool tabAtTop = widget.tabPosition == TabPosition.top;
    return Container(
        padding: widget.padding,
        child: tabAtTop
            ? Column(
                children: [
                  Flexible(flex: 0, child: _renderTabItem()),
                  widget.pages,
                ],
              )
            : Row(children: [
                Flexible(flex: 0, child: _renderTabItem()),
                widget.pages
              ]));
  }
}
