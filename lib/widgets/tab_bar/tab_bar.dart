/*
 * 底部导航栏组件
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 18:10:43 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-06-30 14:13:16
 */
import 'package:flutter/material.dart';
import 'package:pickle_browser/models/app_theme.dart';
import 'package:pickle_browser/models/tab_bar.dart' as TabBarModel;

import 'tab_item.dart';

class TabBar extends StatefulWidget {
  const TabBar({Key? key, this.tabList, this.handleChange}) : super(key: key);

  final Function(TabBarModel.TabItem tabItemData)? handleChange;
  final List<TabBarModel.TabItem>? tabList;
  @override
  _TabBarState createState() => _TabBarState();
}

class _TabBarState extends State<TabBar> with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppTheme.baseAnimationDuration),
    );
    animationController?.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return Transform(
          transform: Matrix4.translationValues(0.0, 0.0, 0.0),
          child: Container(
            color: AppTheme.white,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 62,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                    child: Row(
                      children: widget.tabList!.map((currentTab) {
                        return Expanded(
                          child: TabItem(
                              tabItemData: currentTab,
                              removeAllSelect: () {
                                switchTab(currentTab);
                              }),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void switchTab(TabBarModel.TabItem? tabItemData) {
    if (!mounted) return;
    setState(() {
      widget.tabList?.forEach((TabBarModel.TabItem tab) {
        tab.isSelected = false;
        if (tabItemData!.index == tab.index) {
          tab.isSelected = true;
          // 触发
          widget.handleChange!(tab);
        }
      });
    });
  }
}
