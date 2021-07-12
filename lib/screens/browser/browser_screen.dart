// Copyright 2020 Lorenzo Pichilli
// Reference https://github.com/pichillilorenzo/flutter_browser_app/blob/master/lib/browser.dart
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import 'dart:async';

import 'package:appleickle_browser/models/browser_model.dart';
import 'package:flutter/material.dart';
import 'package:appleickle_browser/models/webview_model.dart';
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
  var _isRestored = false;

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
    return _buildBrowser();
  }

  Widget _buildBrowser() {
    var currentWebViewModel = Provider.of<WebViewModel>(context, listen: true);
    var browserModel = Provider.of<BrowserModel>(context, listen: true);

    browserModel.addListener(() {
      browserModel.save();
    });
    currentWebViewModel.addListener(() {
      browserModel.save();
    });

    return IndexedStack(
      index: 0,
      children: [_buildWebViewTabsScreen()],
    );
  }

  Widget _buildWebViewTabsScreen() {
    return WillPopScope(
        onWillPop: () async {
          var browserModel = Provider.of<BrowserModel>(context, listen: false);
          var webViewModel = browserModel.getCurrentTab()?.webViewModel;
          var _webViewController = webViewModel?.webViewController;

          if (_webViewController != null) {
            if (await _webViewController.canGoBack()) {
              _webViewController.goBack();
              return false;
            }
          }

          if (webViewModel != null && webViewModel.tabIndex != null) {
            setState(() {
              browserModel.closeTab(webViewModel.tabIndex!);
            });
            FocusScope.of(context).unfocus();
            return false;
          }

          return browserModel.webViewTabs.length == 0;
        },
        child: Listener(
          onPointerUp: (_) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild!.unfocus();
            }
          },
          child: _buildWebViewTabsScreenContent(),
        ));
  }

  Widget _buildWebViewTabsScreenContent() {
    var browserModel = Provider.of<BrowserModel>(context, listen: true);

    var stackChildren = <Widget>[
      IndexedStack(
        index: browserModel.getCurrentTabIndex(),
        children: browserModel.webViewTabs.map((webViewTab) {
          var isCurrentTab = webViewTab.webViewModel.tabIndex ==
              browserModel.getCurrentTabIndex();

          if (isCurrentTab) {
            Future.delayed(const Duration(milliseconds: 100), () {
              webViewTab.key.currentState?.onShowTab();
            });
          } else {
            webViewTab.key.currentState?.onHideTab();
          }

          return webViewTab;
        }).toList(),
      ),
      _createProgressIndicator()
    ];

    return Stack(
      children: stackChildren,
    );
  }

  Widget _createProgressIndicator() {
    return Selector<WebViewModel, double>(
        selector: (context, webViewModel) => webViewModel.progress,
        builder: (context, progress, child) {
          if (progress >= 1.0) {
            return Container();
          }
          return PreferredSize(
              preferredSize: Size(double.infinity, 4.0),
              child: SizedBox(
                  height: 4.0,
                  child: LinearProgressIndicator(
                    value: progress,
                  )));
        });
  }
}
