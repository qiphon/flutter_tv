import 'dart:developer';

import 'package:flutter/material.dart';
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
          Container(child: Text('sfdsdsdfs')),
        ]));
  }
}
