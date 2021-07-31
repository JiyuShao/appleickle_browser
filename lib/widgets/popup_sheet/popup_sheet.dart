/*
 * 弹窗菜单
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-31 17:27:54
 */
import 'package:appleickle_browser/models/app_theme_model.dart';
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class PopupSheet extends StatelessWidget {
  // 页面元素
  final Widget child;

  PopupSheet({Key? key, required this.child}) : super(key: key);

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
      sheetBelow: SnappingSheetContent(
        sizeBehavior: SheetSizeStatic(size: 300),
        draggable: true,
        child: Container(
          color: themeData.backgroundColor,
          child: child,
        ),
      ),
    );
  }
}
