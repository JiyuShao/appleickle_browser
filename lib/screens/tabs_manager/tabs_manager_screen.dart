/*
 * 弹窗菜单
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-08-14 18:12:09
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appleickle_browser/widgets/page_scaffold/page_scaffold.dart';
import 'package:appleickle_browser/models/browser_model.dart';
import 'package:appleickle_browser/widgets/popup_sheet/popup_sheet.dart';
import 'package:appleickle_browser/screens/webview_tab/webview_tab_screen.dart';
import 'package:appleickle_browser/screens/tabs_manager/tab_manager_item.dart';

class TabsManagerScreen extends StatefulWidget {
  // 路由名称
  static const routeName = '/tabs_manager';

  @override
  _TabsManagerScreenState createState() => _TabsManagerScreenState();
}

class _TabsManagerScreenState extends State<TabsManagerScreen> {
  // 滚动控制器
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var browserModel = Provider.of<BrowserModel>(context, listen: true);
    // 获取有效的 tabs, 即非空的 tab
    var validWebViewTabs = browserModel.webViewTabs.toList();

    return PageScaffold(
      backgroundColor: Colors.transparent,
      body: PopupSheet(
        scrollController: _scrollController,
        child: Stack(
          fit: StackFit.expand,
          children: [
            validWebViewTabs.length != 0
                ? _buildTabList(validWebViewTabs)
                : _buildEmptyTabList(),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabList(List<WebViewTabScreen> webViewTabs) {
    var themeData = Theme.of(context);
    return ListView.builder(
      controller: _scrollController,
      itemCount: webViewTabs.length,
      itemBuilder: (context, index) {
        final currentTab = webViewTabs[index];
        return Dismissible(
          key: Key(currentTab.hashCode.toString()),
          background: Container(color: themeData.errorColor),
          onDismissed: (_) {
            _handleCloseTab(index);
          },
          child: GestureDetector(
            onTap: () {
              _handleShowTab(index);
            },
            child: TabManagerItem(
              webViewModel: currentTab.webViewModel,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyTabList() {
    var themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 50),
          child: Text(
            '您打开的标签页将显示到这里',
            style: themeData.textTheme.subtitle1?.merge(
              TextStyle(color: themeData.hintColor),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildAddButton() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 65, height: 65),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0),
            ),
            padding: EdgeInsets.all(0),
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 25,
          ),
          onPressed: _handleAddNewTab,
        ),
      ),
    );
  }

  // 添加新的 tab 页
  _handleAddNewTab() {
    var browserModel = Provider.of<BrowserModel>(context, listen: false);
    browserModel.addNewTab();
    // 添加完新页面之后, 关闭当前弹窗
    Navigator.pop(context);
  }

  // 切换 tab
  _handleShowTab(int index) {
    var browserModel = Provider.of<BrowserModel>(context, listen: false);
    browserModel.showTab(index);
    // 切换页面之后, 关闭当前弹窗
    Navigator.pop(context);
  }

  // 删除 tab
  _handleCloseTab(int index) {
    var browserModel = Provider.of<BrowserModel>(context, listen: false);
    browserModel.closeTab(index);
  }
}
