/*
 * 底部导航栏数据模型
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 19:17:54 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-12-11 16:52:13
 */
import 'package:flutter/material.dart';

class BottomBarItemModel {
  BottomBarItemModel({
    required this.index,
    this.builder,
    this.imagePath = '',
    this.handleTap,
  });

  // 当前index
  final int index;
  // 自定义的 widget 渲染
  final Widget Function(BuildContext context, Widget child)? builder;
  // 图标地址
  final String imagePath;
  // 点击回调
  final Function(BottomBarItemModel tabItemData)? handleTap;

  Map<String, dynamic> toJson() {
    return {
      "index": this.index,
      "imagePath": this.imagePath,
    };
  }
}
