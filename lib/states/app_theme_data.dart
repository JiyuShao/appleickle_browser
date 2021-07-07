import 'package:flutter/material.dart';

class AppThemeData {
  // 动画持续时间
  static const int baseAnimationDuration = 120;

  // MaterialApp theme 数据
  final ThemeData materialTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.deepPurple,
    primaryColor: Color(0xFF2633C5),
    backgroundColor: Colors.white,
    dialogBackgroundColor: Colors.black38,
    platform: TargetPlatform.iOS,
  );
}
