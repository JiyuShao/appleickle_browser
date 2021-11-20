/*
 * 弹窗菜单
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-11-06 17:58:30
 */
import 'package:flutter/material.dart';
import 'package:appleickle_browser/widgets/popup/popup.dart';
import 'package:appleickle_browser/screens/popup_menu/popup_menu_hero.dart';

class PopupMenuScreenArguments {
  final String heroTag;
  PopupMenuScreenArguments({required this.heroTag});
}

class PopupMenuScreen extends StatefulWidget {
  // 路由名称
  static const routeName = '/popup_menu';
  // 获取路由参数
  final PopupMenuScreenArguments routeArgs;

  PopupMenuScreen({required this.routeArgs});

  @override
  _PopupMenuScreenState createState() => _PopupMenuScreenState();
}

class _PopupMenuScreenState extends State<PopupMenuScreen> {
  @override
  Widget build(BuildContext context) {
    var routeArgs = widget.routeArgs;
    return Align(
      alignment: Alignment.bottomCenter,
      child: PopupMenuHero(
          heroTag: routeArgs.heroTag,
          child: Popup(
            child: Container(
              alignment: Alignment.topLeft,
              constraints: BoxConstraints(
                minHeight: 100,
                maxHeight: 300,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        //背景装饰
                        gradient: RadialGradient(
                            //背景径向渐变
                            colors: [Colors.red, Colors.orange],
                            center: Alignment.topLeft,
                            radius: .98),
                        boxShadow: [
                          //卡片阴影
                          BoxShadow(
                              color: Colors.black54,
                              offset: Offset(2.0, 2.0),
                              blurRadius: 4.0)
                        ]),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
