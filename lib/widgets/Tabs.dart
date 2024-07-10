import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

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

class Tabs extends StatefulWidget {
  final Widget pages;
  final List<TabItem> tabs;
  final TabPosition tabPosition;

  /// tab 之间的间距
  final double tabSpace;
  final EdgeInsetsGeometry padding;

  const Tabs(
      {super.key,
      required this.pages,
      required this.tabs,
      this.tabSpace = 8,
      this.padding = const EdgeInsets.all(16),
      this.tabPosition = TabPosition.top});

  @override
  State<StatefulWidget> createState() {
    return _TabsState();
  }
}

class _TabsState extends State<Tabs> {
  int _currentTab = 0;

  void _onTabChange(int value) {
    setState(() {
      _currentTab = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(1, 234, 167, 167),
      child: _runderTabWithPosition(),
    );
  }

  Widget _renderText(String text) {
    return Text(style: const TextStyle(fontSize: 24), text);
  }

  List<Widget> _renderTabItemInner() {
    final List<Widget> result = [];
    final itemLen = widget.tabs.length;
    for (int index = 0; index < itemLen; index++) {
      final item = widget.tabs[index];
      result.add(Container(
        child: widget.tabPosition == TabPosition.top
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(item.icon), _renderText(item.title)],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Icon(item.icon), _renderText(item.title)],
              ),
      ));
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
                  // widget.pages
                  Expanded(
                      child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: widget.pages,
                    // child: Text('sdfsdfsd'),
                  ))
                ],
              )
            : Row(children: [
                Flexible(flex: 0, child: _renderTabItem()),
                widget.pages
              ]));
  }
}
