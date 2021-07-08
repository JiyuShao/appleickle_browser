/*
 * 创建命名路由
 * @Author: Jiyu Shao 
 * @Date: 2021-06-30 11:14:55 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-08 11:05:58
 */
import 'package:flutter/material.dart';
import 'package:pickle_browser/models/page_route_model.dart';
import 'package:pickle_browser/utils/logger.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    loggerNoStack.d('RouteGenerator 切换路由中', {
      "setting": {
        'name': settings.name,
        'arguments': settings.arguments,
      }
    });

    try {
      for (var currentRouteConfig in routeListConfig) {
        if (currentRouteConfig.path != settings.name) {
          continue;
        }

        // 获取当前生成的路由
        var result = currentRouteConfig.routeGenerator(settings);
        // 如果返回的是 null, 则进行下一循环
        if (result == null) {
          continue;
        }
        return result;
      }
    } catch (e) {
      loggerNoStack.e('RouteGenerator 切换路径失败', {
        "error": e,
        "settings": {
          'name': settings.name,
          'arguments': settings.arguments,
        },
      });
      return errorRouteConfig.routeGenerator(settings);
    }
    loggerNoStack.e('RouteGenerator 未找到当前路径', {
      "settings": {
        'name': settings.name,
        'arguments': settings.arguments,
      },
    });
    return notFoundRouteConfig.routeGenerator(settings);
  }
}
