/*
 * 底部导航栏数据模型
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 19:17:54 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-01 10:49:50
 */
import 'package:flutter/material.dart';

class BottomBarItem {
  BottomBarItem({
    required this.index,
    required this.isSelected,
    this.diableChange = false,
    this.builder,
    this.imagePath = '',
    this.selectedImagePath = '',
    this.handleTap,
    this.handleChange,
  });

  // 当前index
  final int index;
  // 是否已选中
  bool isSelected;
  // 是否禁用切换
  final bool diableChange;
  // 自定义的 widget 渲染
  final Widget Function(BuildContext context, Widget child)? builder;
  // 未选中的图标地址
  final String imagePath;
  // 选中的图标地址
  final String selectedImagePath;
  // 点击回调
  final Function(BottomBarItem tabItemData)? handleTap;
  // 切换回调
  final Function(BottomBarItem tabItemData)? handleChange;

  Map<String, dynamic> toJson() {
    return {
      "index": this.index,
      "imagePath": this.imagePath,
      "selectedImagePath": this.selectedImagePath,
      "isSelected": this.isSelected
    };
  }
}
