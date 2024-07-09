

import 'dart:developer';

import 'package:flutter/material.dart';

class Tabs extends StatefulWidget {
  final List<Widget> pages;
  final List<Widget> tabs;


  Tabs({required this.pages, required this.tabs});

  @override
  State<StatefulWidget> createState() {
    return _TabsState();
  }
}

class _TabsState extends State<Tabs> {
  int _currentTab = 0;
  PageController _pageController = PageController();

  void _onTabChange(int value) {
    setState(() {
      _currentTab = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: ,)
}