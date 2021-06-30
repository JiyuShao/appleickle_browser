/*
 * 弹出层基础封装
 * @Author: Jiyu Shao 
 * @Date: 2021-06-30 10:57:47 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-06-30 14:13:18
 */
import 'package:flutter/material.dart';
import 'package:pickle_browser/models/app_theme.dart';

import 'popup_tween.dart';

class Popup extends StatelessWidget {
  const Popup(
      {Key? key,
      this.heroTag = 'default-popup-hero-tag',
      this.maskColor = AppTheme.maskColor,
      this.popupElevation = AppTheme.popupElevation})
      : super(key: key);

  // Hero 动画 tag
  final String heroTag;
  // 蒙层背景颜色
  final Color maskColor;
  // 渲染层级
  final double popupElevation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: this.heroTag,
          createRectTween: (begin, end) {
            return PopupRectTween(begin: begin, end: end);
          },
          child: Material(
            color: this.maskColor,
            elevation: this.popupElevation,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'New todo',
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.white,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Write a note',
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.white,
                      maxLines: 6,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
