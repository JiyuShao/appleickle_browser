/*
 * 首页
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-16 10:09:44
 */
import 'package:appleickle_browser/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:appleickle_browser/models/app_theme_model.dart';
import 'package:appleickle_browser/screens/search/search_hero.dart';
import 'package:appleickle_browser/widgets/bottom_bar/bottom_bar.dart'
    as bottom_bar;
import 'package:appleickle_browser/widgets/page_scaffold/page_scaffold.dart';
import 'package:appleickle_browser/widgets/search_bar/search_bar.dart';
import 'package:provider/provider.dart';

class EmptyScreen extends StatefulWidget {
  // Hero 动画相关 tag
  final String heroTag;
  EmptyScreen({required this.heroTag});

  @override
  _EmptyScreenState createState() => _EmptyScreenState();
}

class _EmptyScreenState extends State<EmptyScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final appThemeModel = Provider.of<AppThemeModel>(context, listen: true);
    final mq = MediaQuery.of(context);
    final topOffset = mq.size.height / 3;

    return PageScaffold(
      bottomArea: bottom_bar.BottomBar(
        heroTag: widget.heroTag,
        mode: bottom_bar.BottomBarMode.empty,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(
          appThemeModel.basePagePadding,
          topOffset,
          appThemeModel.basePagePadding,
          appThemeModel.basePagePadding,
        ),
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
              searchScreenArguments:
                  SearchScreenArguments(heroTag: widget.heroTag),
              enabled: false,
              autofocus: false,
            );
          },
          child: SearchBar(
            searchScreenArguments:
                SearchScreenArguments(heroTag: widget.heroTag),
            enabled: false,
            autofocus: false,
          ),
        ),
      ),
    );
  }
}
