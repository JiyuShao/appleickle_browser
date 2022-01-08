/*
 * 设置页面
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 18:10:43 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-12-11 18:07:06
 */
import 'package:flutter/material.dart';
import 'package:appleickle_browser/models/icon_button_item_model.dart';

import '../icon_button_item/icon_button_item.dart';

class SettingGrid extends StatefulWidget {
  const SettingGrid();

  @override
  _SettingGridState createState() => _SettingGridState();
}

class _SettingGridState extends State<SettingGrid>
    with TickerProviderStateMixin {
  // 设置列表
  late List<IconButtonItemModel> settingList = <IconButtonItemModel>[
    IconButtonItemModel(
      imagePath: 'assets/images/icons/favorite.png',
      handleTap: () {},
    ),
    IconButtonItemModel(
      imagePath: 'assets/images/icons/history.png',
      handleTap: () {},
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // 主轴间距
        mainAxisSpacing: 0,
        // 副轴间距
        crossAxisSpacing: 0,
        // 副轴数量
        crossAxisCount: 5,
        //宽高比为1时
        childAspectRatio: 1,
      ),
      children: settingList.map((currentItem) {
        return IconButtonItem(
          model: currentItem,
          handleTap: () {
            if (currentItem.handleTap != null) {
              currentItem.handleTap!();
            }
          },
        );
      }).toList(),
    );
  }
}
