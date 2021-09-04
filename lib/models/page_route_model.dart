/*
 * 路由相关数据
 * @Author: Jiyu Shao 
 * @Date: 2021-06-30 15:29:29 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-09-04 15:00:17
 */
import 'package:flutter/material.dart';
import 'package:appleickle_browser/screens/error_screen.dart';
import 'package:appleickle_browser/screens/browser/browser_screen.dart';
import 'package:appleickle_browser/screens/not_found_screen.dart';
import 'package:appleickle_browser/screens/popup_menu/popup_menu_screen.dart';
import 'package:appleickle_browser/screens/search/search_screen.dart';
import 'package:appleickle_browser/screens/tabs_manager/tabs_manager_screen.dart';
import 'package:appleickle_browser/screens/trex_game_screen.dart';
import 'package:appleickle_browser/utils/routes/page_routes/fade_page_route.dart';
import 'package:appleickle_browser/utils/routes/page_routes/popup_page_route.dart';
import 'package:appleickle_browser/utils/routes/page_routes/search_page_route.dart';

// 路由配置
class PageRouteModel {
  PageRouteModel({
    required this.path,
    required this.routeGenerator,
  });

  // 当前路由路径
  final String path;
  // 当前路由创建方法
  final Route<dynamic>? Function(RouteSettings settings) routeGenerator;

  Map<String, dynamic> toJson() {
    return {
      "path": this.path,
    };
  }
}

// 页面路径配置
List<PageRouteModel> routeListConfig = [
  // 首页页面路径
  PageRouteModel(
    path: BrowserScreen.routeName,
    routeGenerator: (_) => FadePageRoute(
      pageBuilder: (_, __, ___) => BrowserScreen(),
      settings: RouteSettings(name: BrowserScreen.routeName),
    ),
  ),

  // 搜索页面路径
  PageRouteModel(
    path: SearchScreen.routeName,
    routeGenerator: (settings) => SearchPageRoute(
      pageBuilder: (_, __, ___) {
        return SearchScreen(
          routeArgs: settings.arguments as SearchScreenArguments,
        );
      },
      settings: RouteSettings(name: SearchScreen.routeName),
    ),
  ),

  // 弹窗菜单路由
  PageRouteModel(
    path: PopupMenuScreen.routeName,
    routeGenerator: (settings) => PopupPageRoute(
      pageBuilder: (_, __, ___) => PopupMenuScreen(
        routeArgs: settings.arguments as PopupMenuScreenArguments,
      ),
      settings: RouteSettings(name: PopupMenuScreen.routeName),
    ),
  ),

  // Tabs 管理页路由
  PageRouteModel(
    path: TabsManagerScreen.routeName,
    routeGenerator: (settings) => PopupPageRoute(
      pageBuilder: (_, __, ___) => TabsManagerScreen(),
      settings: RouteSettings(name: TabsManagerScreen.routeName),
    ),
  ),

  // TRex Game 路由
  PageRouteModel(
    path: TRexGameScreen.routeName,
    routeGenerator: (_) => FadePageRoute(
      pageBuilder: (_, __, ___) => TRexGameScreen(),
      settings: RouteSettings(name: TRexGameScreen.routeName),
    ),
  ),
];

// 错误路由
PageRouteModel errorRouteConfig = PageRouteModel(
  path: ErrorScreen.routeName,
  routeGenerator: (_) => FadePageRoute(
    pageBuilder: (_, __, ___) => ErrorScreen(),
    settings: RouteSettings(name: ErrorScreen.routeName),
  ),
);

// 404 路由
PageRouteModel notFoundRouteConfig = PageRouteModel(
  path: NotFoundScreen.routeName,
  routeGenerator: (_) => FadePageRoute(
    pageBuilder: (_, __, ___) => NotFoundScreen(),
    settings: RouteSettings(name: NotFoundScreen.routeName),
  ),
);
