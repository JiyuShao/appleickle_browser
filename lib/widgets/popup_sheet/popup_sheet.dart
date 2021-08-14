/*
 * 弹窗菜单
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-08-14 17:05:30
 */
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:appleickle_browser/models/app_theme_model.dart';

class PopupSheet extends StatelessWidget {
  // 页面元素
  final Widget child;
  // 滚动控制器
  final ScrollController? scrollController;

  PopupSheet({
    Key? key,
    required this.child,
    this.scrollController,
  }) : super(key: key);

  final List<SnappingPosition> _snappingPositions = [
    SnappingPosition.factor(
      positionFactor: 0.6,
      snappingCurve: Curves.easeOutBack,
      snappingDuration:
          Duration(milliseconds: AppThemeModel.baseAnimationDuration * 3),
      grabbingContentOffset: GrabbingContentOffset.top,
    ),
    SnappingPosition.factor(
      positionFactor: 0.0,
      snappingCurve: Curves.easeInSine,
      snappingDuration:
          Duration(milliseconds: AppThemeModel.baseAnimationDuration),
      grabbingContentOffset: GrabbingContentOffset.bottom,
    ),
    SnappingPosition.factor(
      positionFactor: 0.9,
      snappingCurve: Curves.easeOutBack,
      snappingDuration:
          Duration(milliseconds: AppThemeModel.baseAnimationDuration * 3),
      grabbingContentOffset: GrabbingContentOffset.top,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return SnappingSheet(
      // 不允许拖拽超出允许区域
      lockOverflowDrag: true,
      snappingPositions: _snappingPositions,
      onSnapCompleted: (positionData, _) {
        // 如果结束后位置为0的话, 则关闭当前路由
        if (positionData.relativeToSnappingPositions == 0.0) {
          Navigator.of(context).pop();
        }
      },
      grabbingHeight: 30,
      grabbing: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: themeData.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 5,
            width: 30,
            decoration: BoxDecoration(
              color: themeData.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
          )
        ],
      ),
      sheetAbove: SnappingSheetContent(
        sizeBehavior: SheetSizeFill(),
        draggable: false,
        child: GestureDetector(
          child: Container(color: Colors.transparent),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      sheetBelow: SnappingSheetContent(
        childScrollController: scrollController,
        sizeBehavior: SheetSizeFill(),
        draggable: true,
        child: Container(
          color: themeData.backgroundColor,
          child: child,
        ),
      ),
    );
  }
}
