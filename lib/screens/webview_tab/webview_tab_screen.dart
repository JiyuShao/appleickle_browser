import 'package:appleickle_browser/screens/webview_tab/empty_screen.dart';
import 'package:appleickle_browser/screens/webview_tab/webview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appleickle_browser/models/webview_model.dart';
import 'package:provider/provider.dart';

class WebViewTabScreen extends StatefulWidget {
  // 创建空的 tab 页面
  static WebViewTabScreen createEmptyWebViewTabScreen() {
    return WebViewTabScreen(key: GlobalKey(), webViewModel: WebViewModel());
  }

  final GlobalKey<WebViewTabScreenState> key;
  final GlobalKey<WebViewScreenState> webViewScreenKey = GlobalKey();

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
            'WEBVIEW_TAB_SCREEN_${widget.webViewModel.tabIndex.toString()}');
  }

  WebViewScreen _buildWebviewScreen() {
    return WebViewScreen(
      key: widget.webViewScreenKey,
      webViewModel: widget.webViewModel,
    );
  }

  // 加载新的路由
  void loadUrl(Uri? url) {
    setState(() {
      // 获取全局的配置
      WebViewModel globalWebViewModel =
          Provider.of<WebViewModel>(context, listen: false);
      widget.webViewModel.url = url;
      globalWebViewModel.updateWithValue(widget.webViewModel);
    });
  }
}
