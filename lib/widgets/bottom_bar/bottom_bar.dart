/*
 * 底部导航栏组件
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 18:10:43 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-12-11 16:53:23
 */
import 'package:flutter/material.dart';
import 'package:appleickle_browser/screens/setting_menu/setting_menu_screen.dart';
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
                );
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
          imagePath: 'assets/images/icons/tabs.png',
          handleTap: (_) {
            Navigator.of(context).pushNamed(TabsManagerScreen.routeName);
          },
        ),
        bottom_bar_model.BottomBarItemModel(
          index: 1,
          imagePath: 'assets/images/icons/menu.png',
          handleTap: (_) {
            Navigator.of(context).pushNamed(
              SettingMenuScreen.routeName,
              arguments: SettingMenuScreenArguments(
                heroTag: widget.heroTag,
              ),
            );
          },
        ),
      ];
    } else {
      bottomBarItemList = [
        bottom_bar_model.BottomBarItemModel(
          index: 0,
          imagePath: 'assets/images/icons/tabs.png',
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
          imagePath: 'assets/images/icons/menu.png',
          handleTap: (_) {
            Navigator.of(context).pushNamed(
              SettingMenuScreen.routeName,
              arguments: SettingMenuScreenArguments(
                heroTag: widget.heroTag,
              ),
            );
          },
        ),
      ];
    }
    return bottomBarItemList;
  }

  // 点击 tab
  void handleTapTab(bottom_bar_model.BottomBarItemModel currentTab) {
    if (!mounted) return;
    if (currentTab.handleTap != null) currentTab.handleTap!(currentTab);
  }
}
