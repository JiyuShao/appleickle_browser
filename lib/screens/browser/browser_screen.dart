/*
 * 浏览器应用入口页面
 * @Author: Jiyu Shao 
 * @Date: 2021-08-21 17:42:50 
 * @Last Modified by:   Jiyu Shao 
 * @Last Modified time: 2021-08-21 17:42:50 
 */
import 'dart:async';

import 'package:appleickle_browser/models/browser_model.dart';
import 'package:flutter/material.dart';
import 'package:appleickle_browser/models/webview_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class BrowserScreen extends StatefulWidget {
  // 路由名称
  static const routeName = '/';

  BrowserScreen({Key? key}) : super(key: key);

  @override
  _BrowserScreenState createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen>
    with SingleTickerProviderStateMixin {
  // 是否 restored
  var _isRestored = false;
  // 是否可以退出应用
  var _canExitApp = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  restore() async {
    var browserModel = Provider.of<BrowserModel>(context, listen: true);
    browserModel.restore();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isRestored) {
      _isRestored = true;
      restore();
    }
  }

  @override
  Widget build(BuildContext context) {
    var browserModel = Provider.of<BrowserModel>(context, listen: true);
    var currentWebViewModel = Provider.of<WebViewModel>(context, listen: true);

    browserModel.addListener(() {
      browserModel.save();
    });
    currentWebViewModel.addListener(() {
      browserModel.save();
    });

    return _buildBrowser();
  }

  Widget _buildBrowser() {
    return WillPopScope(
      onWillPop: () async {
        var browserModel = Provider.of<BrowserModel>(context, listen: false);
        var currentWebViewTab = browserModel.getCurrentTab();
        var _webViewController =
            currentWebViewTab?.webViewModel.webViewController;

        // 如果当前 webview 可以后退的话, 优先后退
        if (_webViewController != null &&
            await _webViewController.canGoBack()) {
          _webViewController.goBack();
          return false;
        }

        // 如果当前 tab 没有可回退的页面的话
        // 再次返回则显示空页面
        if (currentWebViewTab != null &&
            currentWebViewTab.webViewModel.url != null) {
          currentWebViewTab.key.currentState?.loadUrl();
          return false;
        }

        // 执行两次返回关闭逻辑
        if (!_canExitApp) {
          _canExitApp = true;
          Fluttertoast.showToast(
              msg: "再次返回退出应用",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.black45,
              textColor: Colors.white,
              fontSize: 16.0);
          Timer(Duration(seconds: 2), () {
            _canExitApp = false;
          });
          return false;
        }
        Fluttertoast.cancel();
        return true;
      },
      child: _buildWebViewTabs(),
    );
  }

  Widget _buildWebViewTabs() {
    var browserModel = Provider.of<BrowserModel>(context, listen: true);

    return IndexedStack(
      index: browserModel.getCurrentTabIndex(),
      children: browserModel.webViewTabs.map((webViewTab) {
        var isCurrentTab = webViewTab.webViewModel.tabIndex ==
            browserModel.getCurrentTabIndex();

        if (isCurrentTab) {
          Future.delayed(Duration(milliseconds: 100), () {
            webViewTab.webViewScreenKey.currentState?.onShowTab();
          });
        } else {
          webViewTab.webViewScreenKey.currentState?.onHideTab();
        }

        return webViewTab;
      }).toList(),
    );
  }
}
