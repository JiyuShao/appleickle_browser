import 'package:appleickle_browser/screens/webview_tab/empty_screen.dart';
import 'package:appleickle_browser/screens/webview_tab/webview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appleickle_browser/models/webview_model.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewTabScreen extends StatefulWidget {
  // 创建空的 tab 页面
  static WebViewTabScreen createEmptyWebViewTabScreen() {
    return WebViewTabScreen(key: GlobalKey(), webViewModel: WebViewModel());
  }

  // 用户获取对应的 WebViewTabScreen state
  final GlobalKey<WebViewTabScreenState> key;

  // 用于获取对应的 WebViewScreen state
  final GlobalKey<WebViewScreenState> webViewScreenKey = GlobalKey();

  // 从外部接收数据模型
  final WebViewModel webViewModel;

  WebViewTabScreen({required this.key, required this.webViewModel})
      : super(key: key);

  @override
  WebViewTabScreenState createState() => WebViewTabScreenState();
}

class WebViewTabScreenState extends State<WebViewTabScreen>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    // 选择性的渲染页面
    return widget.webViewModel.url == null
        ? _buildEmptyScreen()
        : _buildWebviewScreen();
  }

  EmptyScreen _buildEmptyScreen() {
    return EmptyScreen(
        heroTag:
            'WEBVIEW_TAB_SCREEN/EMPTY_SCREEN_${widget.webViewModel.tabIndex.toString()}');
  }

  WebViewScreen _buildWebviewScreen() {
    return WebViewScreen(
      key: widget.webViewScreenKey,
      heroTag:
          'WEBVIEW_TAB_SCREEN/WEBVIEW_SCREEN_${widget.webViewModel.tabIndex.toString()}',
      webViewModel: widget.webViewModel,
    );
  }

  // 加载新的路由
  Future<void> loadUrl({URLRequest? urlRequest}) async {
    if (widget.webViewModel.webViewController != null && urlRequest != null) {
      // 已经初始化 webViewController 并且 urlRequest 不为空的情况下, 使用 webViewController 来更新 url
      await widget.webViewModel.webViewController!
          .loadUrl(urlRequest: urlRequest);
    } else if (urlRequest != null) {
      // 如果 urlRequest 存在, 代表初始化 webViewController
      setState(() {
        widget.webViewModel.url = urlRequest.url;
      });
    } else {
      // 如果 urlRequest 不存在, 代表销毁 webViewController, 
      // 会触发 WebViewScreen.dispose 和 webViewModel.reset 逻辑
      setState(() {
        widget.webViewModel.url = null;
      });
    }
  }
}
