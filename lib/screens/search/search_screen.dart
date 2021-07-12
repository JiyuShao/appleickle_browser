/*
 * 首页
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-12 10:35:52
 */
import 'dart:async';

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

    final mq = MediaQuery.of(context);
    final topOffset = mq.size.height / 3;
    final bottomOffset = mq.viewInsets.bottom + mq.padding.bottom;
    return PageScaffold(
      // 键盘弹出时不需要 resize body
      resizeToAvoidBottomInset: false,
      safeAreaOptions: {
        // 这里手动计算
        'bottom': false,
      },
      body: AnimatedContainer(
        color: Colors.amberAccent,
        curve: Curves.easeOutQuad,
        duration:
            Duration(milliseconds: AppThemeModel.baseAnimationDuration * 2),
        padding: EdgeInsets.fromLTRB(20, topOffset, 20, bottomOffset + 20),
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
                  Timer(Duration(milliseconds: 20), () {
                    setState(() {
                      _isKeyboardOpen = true;
                    });
                  });
                } else if (keyboardStatus == SearchBarKeyboardStatus.closing) {
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

  void _handleSearch(String searchText) {
    BrowserModel browserModel =
        Provider.of<BrowserModel>(context, listen: false);
    BrowserSettingsModel settings = browserModel.getSettings();

    var currentTab = browserModel.getCurrentTab();
    if (currentTab != null) {
      currentTab.loadUrl(Uri.parse(searchText.startsWith("http")
          ? searchText
          : settings.searchEngine.searchUrl + searchText));
    }
  }
}
