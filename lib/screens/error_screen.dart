/*
 * 404 页面
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-01 13:06:49
 */
import 'package:flutter/material.dart';

class ErrorScreen extends StatefulWidget {
  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Text('ERROR'),
          )),
    );
  }
}
