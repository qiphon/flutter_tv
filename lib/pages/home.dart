import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tv_flutter/api/lives.dart';
import 'package:tv_flutter/pages/homePage.dart';
import 'package:tv_flutter/pages/settings.dart';

typedef ChangeHomeNav = void Function(TabTitle page);

class HomeWithNav extends StatefulWidget {
  const HomeWithNav({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeWithNavState();
  }
}

class _HomeWithNavState extends State<HomeWithNav> {
  bool isCanQuit = false;
  int _currentTab = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    Channel.getAllValues();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    setState(() {
      isCanQuit = false;
    });
  }

  void _onTabChange(int value) {
    _pageController.animateToPage(value,
        duration: const Duration(milliseconds: 300), curve: Curves.bounceIn);
    setState(() {
      _currentTab = value;
      _pageController.jumpToPage(value);
    });
  }

  void _onPageChange(TabTitle page) {
    if (page == TabTitle.home) {
      _pageController.jumpToPage(0);
    } else if (page == TabTitle.settings) {
      _pageController.jumpToPage(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: isCanQuit,
        onPopInvoked: (didPop) {
          if (_pageController.page != 0) {
            _pageController.jumpToPage(0);
            return;
          }

          setState(() {
            isCanQuit = true;
          });
          BrnToast.show(
            '再次返回即可退出',
            context,
            onDismiss: () {
              Future.delayed(const Duration(seconds: 1)).then((v) {
                setState(() {
                  isCanQuit = false;
                });
              });
            },
          );
        },
        child: Scaffold(
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
              children: <Widget>[
                Homepage(changeNav: _onPageChange),
                SettingsPage()
              ],
            )));
  }
}
