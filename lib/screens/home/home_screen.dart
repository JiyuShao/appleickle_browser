/*
 * 首页
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-01 13:02:51
 */
import 'package:flutter/material.dart';
import 'package:pickle_browser/models/app_theme.dart';
import 'package:pickle_browser/screens/search_screen.dart';
import 'package:pickle_browser/screens/popup_menu/popup_menu_hero.dart';
import 'package:pickle_browser/widgets/tab_bar/tab_bar.dart' as tab_bar;
import 'package:pickle_browser/models/tab_bar.dart' as tab_bar_model;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController animationController;
// 首页的Tab列表数据
  late final List<tab_bar_model.TabItem> tabList = [
    tab_bar_model.TabItem(
        index: 0,
        imagePath: 'assets/images/tabs/tab_1.png',
        selectedImagePath: 'assets/images/tabs/tab_1s.png',
        isSelected: true,
        handleChange: (_) {
          animationController.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }
            setState(() {
              tabBody = SearchScreen(animationController: animationController);
            });
          });
        }),
    tab_bar_model.TabItem(
        index: 1,
        imagePath: 'assets/images/tabs/tab_2.png',
        selectedImagePath: 'assets/images/tabs/tab_2s.png',
        isSelected: false,
        handleChange: (_) {
          animationController.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }
            setState(() {
              tabBody = SearchScreen(animationController: animationController);
            });
          });
        }),
    tab_bar_model.TabItem(
      index: 2,
      diableChange: true,
      imagePath: 'assets/images/tabs/tab_3.png',
      selectedImagePath: 'assets/images/tabs/tab_3s.png',
      isSelected: false,
      handleTap: (_) {
        Navigator.of(context).pushNamed('/popup_menu');
      },
      builder: (_, child) => PopupMenuHero(child: child),
    ),
  ];

  Widget? tabBody;

  @override
  void initState() {
    // 设置选中的 Tab
    tabList.forEach((tab_bar_model.TabItem tab) {
      tab.isSelected = false;
    });
    tabList[0].isSelected = true;
    animationController = AnimationController(
        duration: const Duration(milliseconds: AppTheme.baseAnimationDuration),
        vsync: this);
    tabBody = SearchScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody ??
                      Container(
                        color: Theme.of(context).backgroundColor,
                      ),
                  renderBottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // 获取异步的数据
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  // 渲染底部导航栏
  Widget renderBottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        tab_bar.TabBar(
          tabList: tabList,
        ),
      ],
    );
  }
}
