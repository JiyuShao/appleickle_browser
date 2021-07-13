/*
 * 首页
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-12 10:36:02
 */
import 'package:appleickle_browser/screens/popup_menu/popup_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:appleickle_browser/models/app_theme_model.dart';
import 'package:appleickle_browser/screens/popup_menu/popup_menu_hero.dart';
import 'package:appleickle_browser/models/bottom_bar_model.dart'
    as bottom_bar_model;
import 'package:appleickle_browser/screens/search/search_hero.dart';
import 'package:appleickle_browser/widgets/bottom_bar/bottom_bar.dart'
    as bottom_bar;
import 'package:appleickle_browser/widgets/page_scaffold/page_scaffold.dart';
import 'package:appleickle_browser/widgets/search_bar/search_bar.dart';

class EmptyScreen extends StatefulWidget {
  // Hero 动画相关 tag
  final String heroTag;
  EmptyScreen({required this.heroTag});

  @override
  _EmptyScreenState createState() => _EmptyScreenState();
}

class _EmptyScreenState extends State<EmptyScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
// 首页的Tab列表数据
  late final List<bottom_bar_model.BottomBarItemModel> bottomBarItemList = [
    bottom_bar_model.BottomBarItemModel(
        index: 0,
        imagePath: 'assets/images/tabs/tabs.png',
        selectedImagePath: 'assets/images/tabs/tabs.png',
        isSelected: true,
        handleTap: (_) {
          _animationController.reverse();
        }),
    bottom_bar_model.BottomBarItemModel(
      index: 1,
      diableChange: true,
      imagePath: 'assets/images/tabs/settings.png',
      selectedImagePath: 'assets/images/tabs/settings.png',
      isSelected: false,
      handleTap: (_) {
        Navigator.of(context).pushNamed(PopupMenuScreen.routeName,
            arguments: PopupMenuScreenArguments(heroTag: widget.heroTag));
      },
      builder: (_, child) =>
          PopupMenuHero(heroTag: widget.heroTag, child: child),
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
      bottomArea: bottom_bar.BottomBar(
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
                heroTag: widget.heroTag,
                flightShuttleBuilder: (
                  BuildContext flightContext,
                  Animation<double> animation,
                  HeroFlightDirection flightDirection,
                  BuildContext fromHeroContext,
                  BuildContext toHeroContext,
                ) {
                  return SearchBar(
                    heroTag: widget.heroTag,
                    enabled: false,
                    autofocus: false,
                  );
                },
                child: SearchBar(
                  heroTag: widget.heroTag,
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
