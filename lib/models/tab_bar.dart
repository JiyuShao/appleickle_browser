/*
 * 底部导航栏数据模型
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 19:17:54 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-06-29 19:27:26
 */
import 'package:flutter/material.dart';

class TabItem {
  TabItem({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
  });

  final int index;
  final String imagePath;
  final String selectedImagePath;
  bool isSelected;

  AnimationController? animationController;

  Map<String, dynamic> toJson() {
    return {
      "index": this.index,
      "imagePath": this.imagePath,
      "selectedImagePath": this.selectedImagePath,
      "isSelected": this.isSelected
    };
  }
}

// 当前的列表数据
List<TabItem> tabList = <TabItem>[
  TabItem(
    imagePath: 'assets/images/tabs/tab_1.png',
    selectedImagePath: 'assets/images/tabs/tab_1s.png',
    index: 0,
    isSelected: true,
    animationController: null,
  ),
  TabItem(
    imagePath: 'assets/images/tabs/tab_2.png',
    selectedImagePath: 'assets/images/tabs/tab_2s.png',
    index: 1,
    isSelected: false,
    animationController: null,
  ),
];
