import 'package:flutter/material.dart';

class AppTheme {
  // 动画持续时间
  static const int baseAnimationDuration = 120;
  // 静态颜色相关
  static const Color dialogBackgroundColor = Colors.black38;
  // 应用主题数据
  static ThemeData appThemeData = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.deepPurple,
    primaryColor: Color(0xFF2633C5),
    backgroundColor: Colors.white,
    dialogBackgroundColor: Colors.black38,
    platform: TargetPlatform.iOS,
  );
}
