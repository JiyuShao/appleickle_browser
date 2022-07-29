/*
 * 首页
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-09-04 14:57:41
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appleickle_browser/models/browser_model.dart';
import 'package:appleickle_browser/screens/search/search_screen.dart';
import 'package:appleickle_browser/models/app_theme_model.dart';
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
  @override
  Widget build(BuildContext context) {
    BrowserModel browserModel =
        Provider.of<BrowserModel>(context, listen: true);
    // ignore: unused_local_variable
    BrowserSettingsModel settings = browserModel.getSettings();
    final appThemeModel = AppThemeModel.of(context);
    final mq = MediaQuery.of(context);
    final searchBarTopOffset = mq.size.height / 3;

    return PageScaffold(
      bottomArea: bottom_bar.BottomBar(
        heroTag: widget.heroTag,
        mode: bottom_bar.BottomBarMode.empty,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          appThemeModel.basePagePadding,
          0,
          appThemeModel.basePagePadding,
          appThemeModel.basePagePadding,
        ),
        child: Stack(
          children: [
            GestureDetector(
              child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: searchBarTopOffset - 65),
                child: Image.asset(
                  'assets/images/app_logo.png',
                  height: 40,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: searchBarTopOffset),
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
          ],
        ),
      ),
    );
  }
}
