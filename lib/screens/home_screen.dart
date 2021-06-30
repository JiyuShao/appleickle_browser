/*
 * 首页
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-06-30 16:04:31
 */
import 'package:flutter/material.dart';
import 'package:pickle_browser/models/app_theme.dart';
import 'package:pickle_browser/screens/search_screen.dart';
import 'package:pickle_browser/widgets/tab_bar/tab_bar.dart' as TabBar;
import 'package:pickle_browser/models/tab_bar.dart' as TabBarModel;
import 'package:pickle_browser/utils/logger.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabBarModel.TabItem> tabList = TabBarModel.tabList;

  Widget tabBody = Container(
    color: AppTheme.background,
  );

  @override
  void initState() {
    // 设置选中的 Tab
    tabList.forEach((TabBarModel.TabItem tab) {
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
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
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
                  tabBody,
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
        TabBar.TabBar(
          tabList: tabList,
          handleChange: (TabBarModel.TabItem tabItemData) {
            logger.v('切换 Tab', tabItemData.toJson());
            // Navigator.of(context).pushNamed('/popup_menus');
            animationController?.reverse().then<dynamic>((data) {
              if (!mounted) {
                return;
              }
              setState(() {
                tabBody =
                    SearchScreen(animationController: animationController);
              });
            });
          },
        ),
      ],
    );
  }
}
