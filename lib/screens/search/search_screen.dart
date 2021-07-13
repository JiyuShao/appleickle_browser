/*
 * 首页
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-12 10:35:52
 */
import 'dart:async';
import 'dart:math';

import 'package:appleickle_browser/models/browser_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appleickle_browser/models/app_theme_model.dart';
import 'package:appleickle_browser/screens/search/search_hero.dart';
import 'package:appleickle_browser/widgets/page_scaffold/page_scaffold.dart';
import 'package:appleickle_browser/widgets/search_bar/search_bar.dart';

class SearchScreenArguments {
  final String heroTag;
  SearchScreenArguments({required this.heroTag});

  Map<String, dynamic> toJson() {
    return {
      "heroTag": this.heroTag,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class SearchScreen extends StatefulWidget {
  // 路由名称
  static const routeName = '/search';
  // 路由参数
  final SearchScreenArguments routeArgs;

  SearchScreen({required this.routeArgs});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // 键盘是否打开
  bool _isKeyboardOpen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 获取路由参数
    var routeArgs = widget.routeArgs;
    var appThemeModel = Provider.of<AppThemeModel>(context, listen: true);

    return PageScaffold(
      // 键盘弹出时不需要 resize body
      resizeToAvoidBottomInset: false,
      safeAreaOptions: {
        // 这里手动计算
        'bottom': false,
      },
      body: AnimatedContainer(
        curve: Curves.easeOutQuad,
        duration:
            Duration(milliseconds: AppThemeModel.baseAnimationDuration * 2),
        padding: _getSearchScreenPadding(appThemeModel),
        alignment:
            !_isKeyboardOpen ? Alignment.topCenter : Alignment.bottomCenter,
        child: SearchHero(
          heroTag: routeArgs.heroTag,
          flightShuttleBuilder: (
            BuildContext flightContext,
            Animation<double> animation,
            HeroFlightDirection flightDirection,
            BuildContext fromHeroContext,
            BuildContext toHeroContext,
          ) {
            return SearchBar(
              heroTag: routeArgs.heroTag,
              enabled: false,
              autofocus: false,
            );
          },
          child: SearchBar(
              heroTag: routeArgs.heroTag,
              enabled: true,
              autofocus: true,
              handleKeyboardChange: (keyboardStatus) {
                if (keyboardStatus == SearchBarKeyboardStatus.opening) {
                  // 键盘开启的时候延迟 search bar 的开始动画
                  Timer(
                      Duration(
                        milliseconds:
                            appThemeModel.keyboardMaxHeight == null ? 20 : 0,
                      ), () {
                    setState(() {
                      _isKeyboardOpen = true;
                    });
                  });
                } else if (keyboardStatus == SearchBarKeyboardStatus.opened) {
                  // 键盘打开后, 设置当前键盘高度为最大高度
                  appThemeModel.keyboardMaxHeight = _getKeyboardHeight();
                } else if (keyboardStatus == SearchBarKeyboardStatus.closing) {
                  // 键盘关闭时直接执行 search bar 关闭动画
                  setState(() {
                    _isKeyboardOpen = false;
                  });
                  Navigator.pop(context);
                }
              },
              handleSearch: (searchText) {
                _handleSearch(searchText);
              }),
        ),
      ),
    );
  }

  // 获取当前键盘高度
  double _getKeyboardHeight() {
    final mq = MediaQuery.of(context);
    return mq.viewInsets.bottom + mq.padding.bottom;
  }

  // 获取当前页面 padding
  EdgeInsets _getSearchScreenPadding(AppThemeModel appThemeModel) {
    if (!mounted) {
      return EdgeInsets.all(20);
    }

    final mq = MediaQuery.of(context);
    // top 大约在页面三分之一处
    final topOffset = mq.size.height / 3 - 20;

    // 底部优先设置为键盘的最大高度
    double bottomOffset = max(
      _getKeyboardHeight(),
      appThemeModel.keyboardMaxHeight ?? AppThemeModel.keyboardDefaultHeight,
    );
    return EdgeInsets.fromLTRB(20, topOffset + 20, 20, bottomOffset + 20);
  }

  void _handleSearch(String searchText) {
    BrowserModel browserModel =
        Provider.of<BrowserModel>(context, listen: false);
    BrowserSettingsModel settings = browserModel.getSettings();

    var currentTab = browserModel.getCurrentTab();
    if (currentTab != null) {
      currentTab.key.currentState?.loadUrl(Uri.parse(
          searchText.startsWith("http")
              ? searchText
              : settings.searchEngine.searchUrl + searchText));
    }
  }
}
