/*
 * 弹窗菜单
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-12-11 16:38:44
 */
import 'package:flutter/material.dart';
import 'package:appleickle_browser/widgets/popup/popup.dart';

class SettingMenuScreenArguments {
  final String heroTag;
  SettingMenuScreenArguments({required this.heroTag});
}

class SettingMenuScreen extends StatefulWidget {
  // 路由名称
  static const routeName = '/setting_menu';
  // 获取路由参数
  final SettingMenuScreenArguments routeArgs;

  SettingMenuScreen({required this.routeArgs});

  @override
  _SettingMenuScreenState createState() => _SettingMenuScreenState();
}

class _SettingMenuScreenState extends State<SettingMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
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
        ));
  }
}
