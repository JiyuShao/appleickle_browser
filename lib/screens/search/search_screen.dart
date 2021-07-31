/*
 * 首页
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-31 16:43:56
 */
import 'dart:math';

import 'package:appleickle_browser/models/browser_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:appleickle_browser/models/app_theme_model.dart';
import 'package:appleickle_browser/screens/search/search_hero.dart';
import 'package:appleickle_browser/widgets/page_scaffold/page_scaffold.dart';
import 'package:appleickle_browser/widgets/search_bar/search_bar.dart';

class SearchScreenArguments {
  // 当前屏幕 Hero 动画 tag
  final String heroTag;
  // 初始位置
  final Alignment initialAlignment;
  // 搜索框初始值
  final String initialValue;

  SearchScreenArguments({
    required this.heroTag,
    this.initialAlignment = Alignment.topCenter,
    this.initialValue = '',
  });

  Map<String, dynamic> toJson() {
    return {
      "heroTag": this.heroTag,
      "initialAlignment": this.initialAlignment,
      "initialValue": this.initialValue,
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
    var appThemeModel = AppThemeModel.of(context);

    return PageScaffold(
        // 键盘弹出时不需要 resize body
        resizeToAvoidBottomInset: false,
        safeAreaOptions: {
          // 这里手动计算
          'bottom': false,
        },
        body: _getAnimationWidget(
          appThemeModel,
          SearchHero(
            heroTag: routeArgs.heroTag,
            flightShuttleBuilder: (
              BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext,
            ) {
              return SearchBar(
                searchScreenArguments:
                    SearchScreenArguments(heroTag: routeArgs.heroTag),
                enabled: false,
                autofocus: false,
              );
            },
            child: SearchBar(
                initialValue: widget.routeArgs.initialValue,
                searchScreenArguments:
                    SearchScreenArguments(heroTag: routeArgs.heroTag),
                enabled: true,
                autofocus: true,
                handleKeyboardChange: (keyboardStatus) {
                  if (keyboardStatus == SearchBarKeyboardStatus.opening) {
                    // 键盘开启时才进行动画
                    setState(() {
                      _isKeyboardOpen = true;
                    });
                  } else if (keyboardStatus == SearchBarKeyboardStatus.opened) {
                    // 键盘打开后, 设置当前键盘高度为最大高度
                    appThemeModel.keyboardMaxHeight = _getKeyboardHeight();
                  } else if (keyboardStatus ==
                      SearchBarKeyboardStatus.closing) {
                    Navigator.pop(context);
                  }
                },
                handleSearch: (searchText) {
                  _handleSearch(searchText);
                }),
          ),
        ));
  }

  Widget _getAnimationWidget(AppThemeModel appThemeModel, Widget child) {
    return AnimatedContainer(
      curve: widget.routeArgs.initialAlignment != Alignment.bottomCenter
          ? Curves.easeOutBack
          : Curves.easeOutQuart,
      duration: widget.routeArgs.initialAlignment != Alignment.bottomCenter
          ? Duration(milliseconds: AppThemeModel.baseAnimationDuration * 2)
          : Duration(milliseconds: AppThemeModel.baseAnimationDuration),
      padding: _getSearchScreenPadding(appThemeModel),
      alignment: _getSearchScreenAlignment(),
      child: child,
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
      return EdgeInsets.all(appThemeModel.basePagePadding);
    }

    final mq = MediaQuery.of(context);
    // top 大约在页面三分之一处
    final topOffset = mq.size.height / 3;

    double bottomOffset = _getKeyboardHeight();

    // 如果不是 bottomCenter 对齐的情况下, 键盘打开会有从上到下的动画, 所以优先取键盘最大高度
    if (widget.routeArgs.initialAlignment != Alignment.bottomCenter) {
      // 底部优先设置为键盘的最大高度
      bottomOffset = max(
        bottomOffset,
        appThemeModel.keyboardMaxHeight ?? appThemeModel.keyboardDefaultHeight,
      );
    }
    return EdgeInsets.fromLTRB(
        appThemeModel.basePagePadding,
        topOffset,
        appThemeModel.basePagePadding,
        bottomOffset + appThemeModel.basePagePadding);
  }

  Alignment _getSearchScreenAlignment() {
    if (widget.routeArgs.initialAlignment == Alignment.bottomCenter) {
      return Alignment.bottomCenter;
    }
    return !_isKeyboardOpen ? Alignment.topCenter : Alignment.bottomCenter;
  }

  void _handleSearch(String searchText) {
    BrowserModel browserModel =
        Provider.of<BrowserModel>(context, listen: false);
    BrowserSettingsModel settings = browserModel.getSettings();

    var currentTab = browserModel.getCurrentTab();
    if (currentTab != null) {
      currentTab.key.currentState?.loadUrl(
          urlRequest: URLRequest(
              url: Uri.parse(searchText.startsWith("http")
                  ? searchText
                  : settings.searchEngine.searchUrl + searchText)));
    }
  }
}
