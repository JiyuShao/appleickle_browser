/*
 * 弹窗菜单
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-31 15:53:03
 */
import 'package:flutter/material.dart';
import 'package:appleickle_browser/models/app_theme_model.dart';
import 'package:appleickle_browser/widgets/popup_sheet/popup_sheet.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class TabsManagerScreen extends StatefulWidget {
  // 路由名称
  static const routeName = '/tabs_manager';

  @override
  _TabsManagerScreenState createState() => _TabsManagerScreenState();
}

class _TabsManagerScreenState extends State<TabsManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return PopupSheet(child: Text('123'));
  }
}
