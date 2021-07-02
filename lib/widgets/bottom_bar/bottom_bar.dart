/*
 * 底部导航栏组件
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 18:10:43 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-02 18:00:13
 */
import 'package:flutter/material.dart';
import 'package:pickle_browser/models/bottom_bar.dart' as bottom_bar_model;

import 'bottom_bar_item.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key, required this.bottomBarItemList})
      : super(key: key);

  // tabbar 数据列表
  final List<bottom_bar_model.BottomBarItem> bottomBarItemList;

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 62,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: widget.bottomBarItemList.map((currentTab) {
                  Widget currentItem = BottomBarItem(
                      tabItemData: currentTab,
                      handleTap: () {
                        handleTapTab(currentTab);
                      },
                      handleChange: () {
                        handleSwitchTab(currentTab);
                      });
                  // 使用自定义的渲染器
                  if (currentTab.builder != null) {
                    currentItem = currentTab.builder!(context, currentItem);
                  }
                  return Expanded(
                    child: currentItem,
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  // 切换 tab
  void handleSwitchTab(bottom_bar_model.BottomBarItem currentTab) {
    if (!mounted) return;
    setState(() {
      widget.bottomBarItemList.forEach((bottom_bar_model.BottomBarItem tab) {
        tab.isSelected = false;
        // 如果 tab 存在的情况下, 触发回调
        if (currentTab.index == tab.index) {
          tab.isSelected = true;
          // 没有禁止更改的情况下, 触发BottomBarItem更改回调
          if (!tab.diableChange && tab.handleChange != null)
            tab.handleChange!(tab);
        }
      });
    });
  }

  // 点击 tab
  void handleTapTab(bottom_bar_model.BottomBarItem currentTab) {
    if (!mounted) return;
    if (currentTab.handleTap != null) currentTab.handleTap!(currentTab);
  }
}
