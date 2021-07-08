/*
 * 应用主题配置
 * @Author: Jiyu Shao 
 * @Date: 2021-07-07 19:25:46 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-08 11:14:10
 * @Reference https://stackoverflow.com/questions/49172746/is-it-possible-extend-themedata-in-flutter
 */
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class AppThemeModel {
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

// extension BuildContextAppThemeModelExtension on BuildContext {
//   AppThemeModel get theme {
//     return watch<AppThemeModel>();
//   }
// }
