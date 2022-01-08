/*
 * 弹窗菜单
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-12-13 11:00:48
 */
import 'package:flutter/material.dart';
import 'package:appleickle_browser/widgets/popup/popup.dart';
import 'package:appleickle_browser/widgets/setting_grid/setting_grid.dart';

class SettingMenuScreen extends StatefulWidget {
  // 路由名称
  static const routeName = '/setting_menu';

  SettingMenuScreen();

  @override
  _SettingMenuScreenState createState() => _SettingMenuScreenState();
}

class _SettingMenuScreenState extends State<SettingMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Popup(
          child: SettingGrid(),
        ));
  }
}
