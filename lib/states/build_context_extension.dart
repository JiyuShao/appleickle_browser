import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme_data.dart';

extension BuildContextAppThemeDataExtension on BuildContext {
  AppThemeData get theme {
    return watch<AppThemeData>();
  }
}
