/*
 * 底部导航栏组件
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 18:10:43 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-01 13:05:01
 */
import 'package:flutter/material.dart';
import 'package:pickle_browser/models/app_theme.dart';
import 'package:pickle_browser/models/tab_bar.dart' as tab_bar_model;

import 'tab_item.dart';

class TabBar extends StatefulWidget {
  const TabBar({Key? key, required this.tabList}) : super(key: key);

  // tabbar 数据列表
  final List<tab_bar_model.TabItem> tabList;

  @override
  _TabBarState createState() => _TabBarState();
}

class _TabBarState extends State<TabBar> with TickerProviderStateMixin {
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
                children: widget.tabList.map((currentTab) {
                  Widget currentItem = TabItem(
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
  void handleSwitchTab(tab_bar_model.TabItem currentTab) {
    if (!mounted) return;
    setState(() {
      widget.tabList.forEach((tab_bar_model.TabItem tab) {
        tab.isSelected = false;
        // 如果 tab 存在的情况下, 触发回调
        if (currentTab.index == tab.index) {
          tab.isSelected = true;
          // 没有禁止更改的情况下, 触发TabItem更改回调
          if (!tab.diableChange && tab.handleChange != null)
            tab.handleChange!(tab);
        }
      });
    });
  }

  // 点击 tab
  void handleTapTab(tab_bar_model.TabItem currentTab) {
    if (!mounted) return;
    if (currentTab.handleTap != null) currentTab.handleTap!(currentTab);
  }
}
