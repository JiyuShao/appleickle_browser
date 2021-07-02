/*
 * 首页
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-02 17:56:43
 */
import 'package:flutter/material.dart';
import 'package:pickle_browser/models/app_theme.dart';
import 'package:pickle_browser/screens/search_screen.dart';
import 'package:pickle_browser/screens/popup_menu/popup_menu_hero.dart';
import 'package:pickle_browser/models/bottom_bar.dart' as bottom_bar_model;
import 'package:pickle_browser/widgets/bottom_bar/bottom_bar.dart'
    as bottom_bar;
import 'package:pickle_browser/widgets/page_scaffold/page_scaffold.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController animationController;
// 首页的Tab列表数据
  late final List<bottom_bar_model.BottomBarItem> bottomBarItemList = [
    bottom_bar_model.BottomBarItem(
        index: 0,
        imagePath: 'assets/images/tabs/tab_1.png',
        selectedImagePath: 'assets/images/tabs/tab_1s.png',
        isSelected: true,
        handleTap: (_) {
          animationController.reverse();
        }),
    bottom_bar_model.BottomBarItem(
      index: 1,
      diableChange: true,
      imagePath: 'assets/images/tabs/tab_2.png',
      selectedImagePath: 'assets/images/tabs/tab_2s.png',
      isSelected: false,
      handleTap: (_) {
        Navigator.of(context).pushNamed('/popup_menu');
      },
      builder: (_, child) => PopupMenuHero(child: child),
    ),
  ];

  @override
  void initState() {
    // 设置选中的 Tab
    bottomBarItemList.forEach((bottom_bar_model.BottomBarItem tab) {
      tab.isSelected = false;
    });
    bottomBarItemList[0].isSelected = true;
    animationController = AnimationController(
        duration: const Duration(milliseconds: AppTheme.baseAnimationDuration),
        vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      bottomBar: bottom_bar.BottomBar(
        bottomBarItemList: bottomBarItemList,
      ),
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          } else {
            return Container(
              width: 500,
              height: 500,
              color: Colors.amberAccent,
            );
          }
        },
      ),
    );
  }

  // 获取异步的数据
  Future<bool> getData() async {
    await Future<dynamic>.delayed(Duration(milliseconds: 200));
    return true;
  }
}
