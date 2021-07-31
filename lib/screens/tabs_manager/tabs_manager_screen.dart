/*
 * 弹窗菜单
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-31 17:35:25
 */
import 'package:appleickle_browser/widgets/page_scaffold/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appleickle_browser/models/app_theme_model.dart';
import 'package:appleickle_browser/models/browser_model.dart';
import 'package:appleickle_browser/widgets/popup_sheet/popup_sheet.dart';
import 'package:appleickle_browser/screens/webview_tab/webview_tab_screen.dart';

class TabsManagerScreen extends StatefulWidget {
  // 路由名称
  static const routeName = '/tabs_manager';

  @override
  _TabsManagerScreenState createState() => _TabsManagerScreenState();
}

class _TabsManagerScreenState extends State<TabsManagerScreen> {
  @override
  Widget build(BuildContext context) {
    var appThemeModel = AppThemeModel.of(context);
    var browserModel = Provider.of<BrowserModel>(context, listen: true);
    // 获取有效的 tabs, 即非空的 tab
    var validWebViewTabs = browserModel.webViewTabs
        .where(
          (currentTab) => currentTab.webViewModel.url != null,
        )
        .toList();

    return PageScaffold(
      backgroundColor: Colors.transparent,
      body: PopupSheet(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            appThemeModel.basePagePadding,
            0.0,
            appThemeModel.basePagePadding,
            appThemeModel.basePagePadding,
          ),
          child: validWebViewTabs.length != 0
              ? _buildTabList(validWebViewTabs)
              : _buildEmpty(),
        ),
      ),
    );
  }

  Widget _buildTabList(List<WebViewTabScreen> webViewTabs) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: webViewTabs.map((currentTab) {
        var currentWebViewModel = currentTab.webViewModel;
        print('### TODO ${currentTab.webViewModel.url}');
        return Container(
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Image(
                image: MemoryImage(currentWebViewModel.screenshot!),
              )
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmpty() {
    var themeData = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 90),
          child: Text(
            '您打开的标签页将显示到这里',
            style: themeData.textTheme.headline6?.merge(
              TextStyle(color: themeData.primaryColorDark),
            ),
          ),
        )
      ],
    );
  }
}
