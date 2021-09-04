/*
 * 底部导航栏组件
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 18:10:43 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-09-04 15:30:08
 */
import 'package:flutter/material.dart';
import 'package:appleickle_browser/screens/popup_menu/popup_menu_hero.dart';
import 'package:appleickle_browser/screens/popup_menu/popup_menu_screen.dart';
import 'package:appleickle_browser/screens/search/search_hero.dart';
import 'package:appleickle_browser/screens/search/search_screen.dart';
import 'package:appleickle_browser/screens/tabs_manager/tabs_manager_screen.dart';
import 'package:appleickle_browser/widgets/search_bar/search_bar.dart';
import 'package:appleickle_browser/models/bottom_bar_model.dart'
    as bottom_bar_model;

import 'bottom_bar_item.dart';

enum BottomBarMode {
  // 空页面
  empty,
  // webview 页面
  webview,
}

class BottomBar extends StatefulWidget {
  // Hero 动画相关 tag
  final String heroTag;
  // 当前展示模式
  final BottomBarMode mode;
  // 当前底部标题
  final String title;
  // 当前访问 urk
  final String url;

  const BottomBar({
    required this.heroTag,
    required this.mode,
    this.title = '',
    this.url = '',
  });

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with TickerProviderStateMixin {
  // 首页的Tab列表数据
  late List bottomBarItemList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Row(
              children: _getBottomBarItemList().map((currentItem) {
                // 允许渲染 BottomBarItem 或者自定义的组件
                if (!(currentItem is bottom_bar_model.BottomBarItemModel) &&
                    currentItem is Widget) {
                  return Expanded(
                    child: currentItem,
                  );
                }
                Widget currentResult = BottomBarItem(
                    tabItemData: currentItem,
                    handleTap: () {
                      handleTapTab(currentItem);
                    },
                    handleChange: () {
                      handleSwitchTab(currentItem);
                    });
                // 使用自定义的渲染器
                if (currentItem.builder != null) {
                  currentResult = currentItem.builder!(context, currentResult);
                }
                return Expanded(
                  child: currentResult,
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  List _getBottomBarItemList() {
    if (widget.mode == BottomBarMode.empty) {
      bottomBarItemList = [
        bottom_bar_model.BottomBarItemModel(
          index: 0,
          imagePath: 'assets/images/bottom_bar/tabs.png',
          selectedImagePath: 'assets/images/bottom_bar/tabs.png',
          isSelected: false,
          handleTap: (_) {
            Navigator.of(context).pushNamed(TabsManagerScreen.routeName);
          },
        ),
        bottom_bar_model.BottomBarItemModel(
          index: 1,
          diableChange: true,
          imagePath: 'assets/images/bottom_bar/settings.png',
          selectedImagePath: 'assets/images/bottom_bar/settings.png',
          isSelected: false,
          handleTap: (_) {
            Navigator.of(context).pushNamed(
              PopupMenuScreen.routeName,
              arguments: PopupMenuScreenArguments(
                heroTag: widget.heroTag,
              ),
            );
          },
          builder: (_, child) =>
              PopupMenuHero(heroTag: widget.heroTag, child: child),
        ),
      ];
    } else {
      bottomBarItemList = [
        bottom_bar_model.BottomBarItemModel(
          index: 0,
          imagePath: 'assets/images/bottom_bar/tabs.png',
          selectedImagePath: 'assets/images/bottom_bar/tabs.png',
          isSelected: false,
          handleTap: (_) {
            Navigator.of(context).pushNamed(TabsManagerScreen.routeName);
          },
        ),
        SearchHero(
          heroTag: widget.heroTag,
          child: SearchBar(
            initialValue: widget.title,
            searchScreenArguments: SearchScreenArguments(
              heroTag: widget.heroTag,
              initialAlignment: Alignment.bottomCenter,
              initialValue: widget.url,
            ),
            mode: SearchBarMode.bottomBar,
            enabled: false,
            autofocus: false,
          ),
        ),
        bottom_bar_model.BottomBarItemModel(
          index: 1,
          diableChange: true,
          imagePath: 'assets/images/bottom_bar/settings.png',
          selectedImagePath: 'assets/images/bottom_bar/settings.png',
          isSelected: false,
          handleTap: (_) {
            Navigator.of(context).pushNamed(
              PopupMenuScreen.routeName,
              arguments: PopupMenuScreenArguments(
                heroTag: widget.heroTag,
              ),
            );
          },
          builder: (_, child) =>
              PopupMenuHero(heroTag: widget.heroTag, child: child),
        ),
      ];
    }
    return bottomBarItemList;
  }

  // 切换 tab
  void handleSwitchTab(bottom_bar_model.BottomBarItemModel currentTab) {
    if (!mounted) return;
    setState(() {
      bottomBarItemList.forEach((tab) {
        // 仅处理 tab 元素
        if (!(tab is bottom_bar_model.BottomBarItemModel)) {
          return;
        }
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
  void handleTapTab(bottom_bar_model.BottomBarItemModel currentTab) {
    if (!mounted) return;
    if (currentTab.handleTap != null) currentTab.handleTap!(currentTab);
  }
}
