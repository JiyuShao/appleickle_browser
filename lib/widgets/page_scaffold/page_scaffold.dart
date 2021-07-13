/*
 * 基础页面脚手架
 * @Author: Jiyu Shao 
 * @Date: 2021-07-02 17:39:20 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-02 18:05:34
 */
import 'package:flutter/material.dart';

class PageScaffold extends StatelessWidget {
  // 页面元素
  final Widget body;
  // 自定义的 bottomArea
  final Widget? bottomArea;
  // 键盘弹出时是否 resize body
  final bool? resizeToAvoidBottomInset;
  // safeArea的配置
  final Map<String, dynamic>? safeAreaOptions;

  const PageScaffold(
      {required this.body,
      this.bottomArea,
      this.resizeToAvoidBottomInset,
      this.safeAreaOptions});

  // 暴露构建响应式的安全的页面
  static Widget responsive({required LayoutWidgetBuilder builder}) {
    return _buildSafeScaffold(
      child: LayoutBuilder(builder: (context, constraints) {
        return builder(context, constraints);
      }),
    );
  }

  // 构建安全的页面
  static _buildSafeScaffold({required Widget child}) {
    return Scaffold(
        body: SafeArea(
      child: child,
    ));
  }

  @override
  Widget build(BuildContext context) {
    // 页面元素
    List<Widget> pageBody = [
      Expanded(
        child: body,
      )
    ];

    // 添加自定义的 bottomBar
    if (bottomArea != null) pageBody.add(bottomArea!);

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        bottom: safeAreaOptions?['bottom'] == true,
        child: Column(
          children: pageBody,
        ),
      ),
    );
  }
}
