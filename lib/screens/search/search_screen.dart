/*
 * 首页
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-07 10:24:33
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pickle_browser/models/app_theme.dart';
import 'package:pickle_browser/screens/search/search_hero.dart';
import 'package:pickle_browser/widgets/page_scaffold/page_scaffold.dart';
import 'package:pickle_browser/widgets/search_bar/search_bar.dart';

class SearchScreen extends StatefulWidget {
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
        duration: Duration(milliseconds: AppTheme.baseAnimationDuration * 2),
        padding: EdgeInsets.fromLTRB(20, topOffset, 20, bottomOffset + 20),
        alignment:
            !_isKeyboardOpen ? Alignment.topCenter : Alignment.bottomCenter,
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
          ),
        ),
      ),
    );
  }
}
