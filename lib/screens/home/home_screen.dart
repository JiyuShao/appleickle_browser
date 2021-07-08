/*
 * 首页
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-08 11:03:15
 */
import 'package:flutter/material.dart';
import 'package:pickle_browser/models/app_theme_model.dart';
import 'package:pickle_browser/screens/popup_menu/popup_menu_hero.dart';
import 'package:pickle_browser/models/bottom_bar_model.dart' as bottom_bar_model;
import 'package:pickle_browser/screens/search/search_hero.dart';
import 'package:pickle_browser/widgets/bottom_bar/bottom_bar.dart'
    as bottom_bar;
import 'package:pickle_browser/widgets/page_scaffold/page_scaffold.dart';
import 'package:pickle_browser/widgets/search_bar/search_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _animationController;
// 首页的Tab列表数据
  late final List<bottom_bar_model.BottomBarItemModel> bottomBarItemList = [
    bottom_bar_model.BottomBarItemModel(
        index: 0,
        imagePath: 'assets/images/tabs/tab_1.png',
        selectedImagePath: 'assets/images/tabs/tab_1s.png',
        isSelected: true,
        handleTap: (_) {
          _animationController.reverse();
        }),
    bottom_bar_model.BottomBarItemModel(
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
    bottomBarItemList.forEach((bottom_bar_model.BottomBarItemModel tab) {
      tab.isSelected = false;
    });
    bottomBarItemList[0].isSelected = true;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: AppThemeModel.baseAnimationDuration),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final topOffset = mq.size.height / 3;
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
              padding: EdgeInsets.fromLTRB(20, topOffset, 20, 20),
              alignment: Alignment.topCenter,
              child: SearchHero(
                flightShuttleBuilder: (
                  BuildContext flightContext,
                  Animation<double> animation,
                  HeroFlightDirection flightDirection,
                  BuildContext fromHeroContext,
                  BuildContext toHeroContext,
                ) {
                  return SearchBar(
                    enabled: false,
                    autofocus: false,
                  );
                },
                child: SearchBar(
                  enabled: false,
                  autofocus: false,
                ),
              ),
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
