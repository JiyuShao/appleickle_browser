/*
 * 404 页面
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-02 18:04:54
 */
import 'package:flutter/material.dart';
import 'package:appleickle_browser/widgets/page_scaffold/page_scaffold.dart';

class NotFoundScreen extends StatefulWidget {
  // 路由名称
  static const routeName = '/not_found';
  @override
  _NotFoundScreenState createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        body: Center(
      child: Text('ERROR'),
    ));
  }
}
