import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tv_flutter/widgets/BoxShadow.dart';
import 'package:tv_flutter/widgets/Tabs.dart';
// import 'package:tv_flutter/pages/settings.dart';

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomepageState();
  }
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onTabChange() {
    var a;
    // a = this;
    // a = null;
    // a = 2;
    a = 'str';

    Object? a1;
    a1 = this;
    a1 = 1;
    a1 = 'str';
    a1 = null;
    dynamic a2;
    a2 = this;
    a2 = 1;
    a2 = 'str';
    a2 = null;
    log('tab change ${a}');
  }

  @override
  Widget build(BuildContext context) {
    log('render home page');
    return SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Text('data'),
          Text('2'),
          GestureDetector(
            onTap: onTabChange,
            child: Container(
              child: Text('containser'),
            ),
          ),
          Container(child: Text(' tabs 顶部')),
          Expanded(
              child: Tabs(
                  // tabPosition: TabPosition.left,
                  pages: Expanded(
                      child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: LineShadow(
                      // shadowDirection: Direction.top,
                      child: Text('pages'),
                    ),
                    // child: Text('pages'),
                    // Column(children: [
                    //   ClipRect(
                    //     clipBehavior: Clip.antiAlias,
                    //     clipper: RectClipper(direction: Direction.top),
                    //     child: Container(
                    //       width: double.infinity,
                    //       height: 1,
                    //       decoration: const BoxDecoration(
                    //           color: Colors.transparent,
                    //           boxShadow: [
                    //             BoxShadow(
                    //                 blurStyle: BlurStyle.outer,
                    //                 blurRadius: 10,
                    //                 spreadRadius: 1,
                    //                 offset: Offset(0, -1),
                    //                 color: Color.fromRGBO(232, 40, 40, 1))
                    //           ]),
                    //     ),
                    //   ),
                    //   Text('pages')
                    // ])),
                  )),
                  tabs: const [
                TabItem(title: '直播', icon: Icons.home),
                TabItem(title: '央视', icon: Icons.home)
              ])),
        ]));
  }
}
