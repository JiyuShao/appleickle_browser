/*
 * 首页
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-06 19:53:01
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
  bool _heroAnimationFinished = false;

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
    final bottomOffset = mq.viewInsets.bottom + mq.padding.bottom;

    return PageScaffold(
      // 键盘弹出时不需要 resize body
      resizeToAvoidBottomInset: false,
      safeAreaOptions: {
        // 这里手动计算
        'bottom': false,
      },
      body: Container(
        color: Colors.amberAccent,
        padding: EdgeInsets.all(20),
        child: AnimatedContainer(
          curve: Curves.easeOutQuad,
          duration: Duration(milliseconds: AppTheme.baseAnimationDuration),
          padding: EdgeInsets.only(bottom: bottomOffset),
          alignment: _heroAnimationFinished
              ? Alignment.bottomCenter
              : Alignment.topCenter,
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
                if (keyboardStatus == SearchBarKeyboardStatus.opened) {
                  setState(() {
                    _heroAnimationFinished = true;
                  });
                } else if (keyboardStatus == SearchBarKeyboardStatus.closing) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
