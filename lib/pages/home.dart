import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tv_flutter/pages/homePage.dart';
import 'package:tv_flutter/pages/settings.dart';

class HomeWithNav extends StatefulWidget {
  const HomeWithNav({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeWithNavState();
  }
}

class _HomeWithNavState extends State<HomeWithNav> {
  int _currentTab = 0;
  PageController _pageController = PageController();

  void _onTabChange(int value) {
    _pageController.animateToPage(value,
        duration: const Duration(milliseconds: 300), curve: Curves.bounceIn);
    setState(() {
      _currentTab = value;
      _pageController.jumpToPage(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'settings',
            ),
          ],
          currentIndex: _currentTab,
          onTap: _onTabChange,
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (val) => setState(() {
            _currentTab = val;
          }),
          children: <Widget>[Homepage(), SettingsPage()],
        ));
  }
}
