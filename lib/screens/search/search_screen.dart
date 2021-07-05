/*
 * 首页
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-05 10:35:06
 */
import 'package:flutter/material.dart';
import 'package:pickle_browser/screens/search/search_hero.dart';
import 'package:pickle_browser/widgets/page_scaffold/page_scaffold.dart';
import 'package:pickle_browser/widgets/search_bar/search_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
    return PageScaffold(
      body: Container(
        color: Colors.amberAccent,
        padding: EdgeInsets.all(20),
        alignment: Alignment.bottomCenter,
        child: SearchHero(child: SearchBar()),
      ),
    );
  }
}
