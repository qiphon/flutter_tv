import 'package:flutter/material.dart';
import 'package:tv_flutter/pages/home.dart';
import 'package:tv_flutter/widgets/lineShadow.dart';
import 'package:tv_flutter/widgets/Tabs.dart';
import 'package:tv_flutter/widgets/weather.dart';

enum TabTitle {
  home,
  live,
  cctv,
  settings,
}

const defaultTabTitleStr = '首页';
const titleMap = {
  TabTitle.home: defaultTabTitleStr,
  TabTitle.live: '直播',
  TabTitle.cctv: '央视',
  TabTitle.settings: '设置',
};

String getTabTitle(TabTitle titleEn) {
  final res = titleMap[titleEn];
  return res ?? defaultTabTitleStr;
}

class Homepage extends StatefulWidget {
  final ChangeHomeNav? changeNav;
  const Homepage({super.key, this.changeNav});

  @override
  State<StatefulWidget> createState() {
    return _HomepageState();
  }
}

class _HomepageState extends State<Homepage> {
  int _activeTab = 0;

  _HomepageState();

  void _onTabChange(int index) {
    if (TabTitle.values[index] == TabTitle.settings) {
      if (widget.changeNav != null) {
        widget.changeNav!(TabTitle.settings);
      }
    }
  }

  void changeTtt(int val) {
    setState(() {
      _activeTab = val > 3 ? 0 : val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          GestureDetector(
            onTap: () => changeTtt(_activeTab + 1),
            child: Container(
              child: Text('change tab ${_activeTab}'),
            ),
          ),
          Expanded(
              child: Tabs(
                  iconSize: 40,
                  tabSpace: 130,
                  onTabChange: _onTabChange,
                  pages: const Expanded(
                      child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: LineShadow(
                        shadowDirection: Direction.top, child: WeatherWidget()),
                  )),
                  tabs: [
                TabItem(
                    title: getTabTitle(TabTitle.home),
                    icon: Icons.home_outlined),
                TabItem(title: getTabTitle(TabTitle.live), icon: Icons.live_tv),
                TabItem(
                    title: getTabTitle(TabTitle.cctv), icon: Icons.tv_sharp),
                TabItem(
                    title: getTabTitle(TabTitle.settings),
                    icon: Icons.settings_outlined)
              ])),
        ]));
  }
}
