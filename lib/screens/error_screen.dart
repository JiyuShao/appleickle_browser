/*
 * 404 页面
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-12 10:28:22
 */
import 'package:flutter/material.dart';
import 'package:appleickle_browser/widgets/page_scaffold/page_scaffold.dart';

class ErrorScreen extends StatefulWidget {
  // 路由名称
  static const routeName = '/error';
  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        body: Center(
      child: Text('ERROR'),
    ));
  }
}
