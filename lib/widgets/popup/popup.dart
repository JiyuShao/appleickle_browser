/*
 * 弹出窗口样式
 * @Author: Jiyu Shao 
 * @Date: 2021-11-06 17:35:44 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-11-06 17:54:12
 */
import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  final Widget? child;
  final double grabbingHeight;

  Popup({this.grabbingHeight = 30.0, this.child});

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          padding: EdgeInsets.only(top: grabbingHeight),
          decoration: BoxDecoration(
            color: themeData.backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(grabbingHeight),
              topRight: Radius.circular(grabbingHeight),
            ),
          ),
          child: child,
        ),
        Padding(
          padding: EdgeInsets.only(top: (grabbingHeight - 5) / 2),
          child: Container(
            height: 5,
            width: 30,
            decoration: BoxDecoration(
              color: themeData.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }
}
