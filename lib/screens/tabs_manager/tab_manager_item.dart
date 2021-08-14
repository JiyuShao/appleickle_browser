/*
 * 基础页面脚手架
 * @Author: Jiyu Shao 
 * @Date: 2021-07-02 17:39:20 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-08-14 17:22:57
 */
import 'package:flutter/material.dart';
import 'package:appleickle_browser/models/webview_model.dart';

class TabManagerItem extends StatelessWidget {
  // 页面元素
  final WebViewModel webViewModel;

  const TabManagerItem({
    required this.webViewModel,
  });

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);

    // 获取当前 tab 缩略图
    DecorationImage currentScreenshot = DecorationImage(
      image: webViewModel.screenshot != null
          ? MemoryImage(webViewModel.screenshot!) as ImageProvider
          : AssetImage('assets/images/empty.png'),
      alignment: Alignment.topCenter,
      fit: webViewModel.screenshot != null ? BoxFit.cover : BoxFit.contain,
    );

    String currentTitle = webViewModel.title ?? '空页面';
    String currentUrl =
        webViewModel.url != null ? webViewModel.url.toString() : 'BLANK_URL';
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(
          width: 1,
          color: Colors.black.withOpacity(0.05),
        ),
      )),
      child: Row(
        children: [
          // 缩略图
          Container(
            width: 110,
            height: 80,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              image: currentScreenshot,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              border: Border.all(
                width: 1,
                color: Colors.black.withOpacity(0.05),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          // 缩略图文字信息
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentTitle,
                  style: themeData.textTheme.subtitle1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    currentUrl,
                    style: themeData.textTheme.caption?.merge(
                      TextStyle(color: themeData.hintColor),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
