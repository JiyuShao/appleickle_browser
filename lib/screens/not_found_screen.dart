/*
 * 404 页面
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-06-30 15:05:00
 */
import 'package:flutter/material.dart';
import 'package:pickle_browser/models/app_theme.dart';

class NotFoundScreen extends StatefulWidget {
  @override
  _NotFoundScreenState createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Text('NOT_FOUND'),
          )),
    );
  }
}
