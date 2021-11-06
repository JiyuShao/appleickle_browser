import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:appleickle_browser/utils/logger.dart';
import 'package:appleickle_browser/widgets/page_scaffold/page_scaffold.dart';
import 'package:appleickle_browser/widgets/progress_indicator/progress_indicator.dart';
import 'package:appleickle_browser/utils/url_helper.dart';
import 'package:appleickle_browser/models/browser_model.dart';
import 'package:appleickle_browser/models/webview_model.dart';
import 'package:appleickle_browser/widgets/bottom_bar/bottom_bar.dart'
    as bottom_bar;

class WebViewScreen extends StatefulWidget {
  final GlobalKey<WebViewScreenState> key;
  // Hero 动画相关 tag
  final String heroTag;

  final WebViewModel webViewModel;

  WebViewScreen({
    required this.key,
    required this.heroTag,
    required this.webViewModel,
  }) : super(key: key);

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen>
    with WidgetsBindingObserver {
  // webview 控制器
  InAppWebViewController? _webViewController;

  TextEditingController _httpAuthUsernameController = TextEditingController();
  TextEditingController _httpAuthPasswordController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    _webViewController = null;
    widget.webViewModel.reset();

    _httpAuthUsernameController.dispose();
    _httpAuthPasswordController.dispose();

    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_webViewController != null && Platform.isAndroid) {
      if (state == AppLifecycleState.paused) {
        pauseAll();
      } else {
        resumeAll();
      }
    }
  }

  void pauseAll() {
    if (Platform.isAndroid) {
      _webViewController?.android.pause();
    }
    pauseTimers();
  }

  void resumeAll() {
    if (Platform.isAndroid) {
      _webViewController?.android.resume();
    }
    resumeTimers();
  }

  void pause() {
    if (Platform.isAndroid) {
      _webViewController?.android.pause();
    }
  }

  void resume() {
    if (Platform.isAndroid) {
      _webViewController?.android.resume();
    }
  }

  void pauseTimers() {
    _webViewController?.pauseTimers();
  }

  void resumeTimers() {
    _webViewController?.resumeTimers();
  }

  @override
  Widget build(BuildContext context) {
    return _buildWebView();
  }

  // 构建 webview 区域
  Widget _buildWebView() {
    // 监听数据的改动
    var browserModel = Provider.of<BrowserModel>(context, listen: false);
    var settings = browserModel.getSettings();

    if (Platform.isAndroid) {
      AndroidInAppWebViewController.setWebContentsDebuggingEnabled(
          settings.debuggingEnabled);
    }

    var initialOptions = widget.webViewModel.options!;
    initialOptions.crossPlatform.useOnDownloadStart = true;
    initialOptions.crossPlatform.useOnLoadResource = true;
    initialOptions.crossPlatform.useShouldOverrideUrlLoading = true;
    initialOptions.crossPlatform.javaScriptCanOpenWindowsAutomatically = true;
    initialOptions.crossPlatform.userAgent =
        "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36";
    initialOptions.crossPlatform.transparentBackground = true;

    initialOptions.android.safeBrowsingEnabled = true;
    initialOptions.android.disableDefaultErrorPage = true;
    initialOptions.android.supportMultipleWindows = true;
    initialOptions.android.useHybridComposition = true;
    initialOptions.android.verticalScrollbarThumbColor =
        Color.fromRGBO(0, 0, 0, 0.5);
    initialOptions.android.horizontalScrollbarThumbColor =
        Color.fromRGBO(0, 0, 0, 0.5);

    initialOptions.ios.allowsLinkPreview = false;
    initialOptions.ios.isFraudulentWebsiteWarningEnabled = true;
    initialOptions.ios.disableLongPressContextMenuOnLinks = true;
    // initialOptions.ios.allowingReadAccessTo =
    //     Uri.parse('file://$WEB_ARCHIVE_DIR/');

    // 渲染 webview
    Widget renderWebview = widget.webViewModel.url == null
        ? Container()
        : InAppWebView(
            initialUrlRequest: URLRequest(url: widget.webViewModel.url),
            initialOptions: initialOptions,
            windowId: widget.webViewModel.windowId,
            onWebViewCreated: (controller) async {
              initialOptions.crossPlatform.transparentBackground = false;
              await controller.setOptions(options: initialOptions);

              _webViewController = controller;
              widget.webViewModel.webViewController = controller;

              if (Platform.isAndroid) {
                controller.android.startSafeBrowsing();
              }

              widget.webViewModel.options = await controller.getOptions();

              updateGlobalWebViewModel();
            },
            onLoadStart: (controller, url) async {
              widget.webViewModel.isSecure = UrlHelper.urlIsSecure(url!);
              widget.webViewModel.url = url;
              widget.webViewModel.loaded = false;
              widget.webViewModel.setLoadedResources([]);
              widget.webViewModel.setJavaScriptConsoleResults([]);

              if (isCurrentTab()) {
                updateGlobalWebViewModel();
              } else if (widget.webViewModel.needsToCompleteInitialLoad) {
                controller.stopLoading();
              }
            },
            onLoadStop: (controller, url) async {
              widget.webViewModel.url = url;
              widget.webViewModel.favicon = null;
              widget.webViewModel.loaded = true;

              var sslCertificateFuture = _webViewController?.getCertificate();
              var titleFuture = _webViewController?.getTitle();
              var faviconsFuture = _webViewController?.getFavicons();

              var sslCertificate = await sslCertificateFuture;
              if (sslCertificate == null &&
                  !UrlHelper.isLocalizedContent(url!)) {
                widget.webViewModel.isSecure = false;
              }

              widget.webViewModel.title = await titleFuture;

              List<Favicon>? favicons = await faviconsFuture;
              if (favicons != null && favicons.isNotEmpty) {
                for (var fav in favicons) {
                  if (widget.webViewModel.favicon == null) {
                    widget.webViewModel.favicon = fav;
                  } else {
                    if ((widget.webViewModel.favicon!.width == null &&
                            !widget.webViewModel.favicon!.url
                                .toString()
                                .endsWith("favicon.ico")) ||
                        (fav.width != null &&
                            widget.webViewModel.favicon!.width != null &&
                            fav.width! > widget.webViewModel.favicon!.width!)) {
                      widget.webViewModel.favicon = fav;
                    }
                  }
                }
              }

              if (isCurrentTab()) {
                widget.webViewModel.needsToCompleteInitialLoad = false;
                var screenshotData = _webViewController
                    ?.takeScreenshot(
                        screenshotConfiguration: ScreenshotConfiguration(
                            compressFormat: CompressFormat.JPEG, quality: 20))
                    .timeout(
                      Duration(milliseconds: 1500),
                      onTimeout: () => null,
                    );
                widget.webViewModel.screenshot = await screenshotData;
                updateGlobalWebViewModel();
              }
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                widget.webViewModel.progress = progress / 100;
              });
              updateGlobalWebViewModel();
            },
            onUpdateVisitedHistory: (controller, url, androidIsReload) async {
              widget.webViewModel.url = url;
              widget.webViewModel.title = await _webViewController?.getTitle();
              updateGlobalWebViewModel();
            },
            onLongPressHitTestResult: (controller, hitTestResult) async {},
            onConsoleMessage: (controller, consoleMessage) {},
            onLoadResource: (controller, resource) {
              widget.webViewModel.addLoadedResources(resource);
              updateGlobalWebViewModel();
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              return NavigationActionPolicy.ALLOW;
            },
            onDownloadStart: (controller, url) async {},
            onReceivedServerTrustAuthRequest: (controller, challenge) async {
              var sslError = challenge.protectionSpace.sslError;
              if (sslError != null &&
                  (sslError.iosError != null ||
                      sslError.androidError != null)) {
                if (Platform.isIOS &&
                    sslError.iosError == IOSSslError.UNSPECIFIED) {
                  return ServerTrustAuthResponse(
                      action: ServerTrustAuthResponseAction.PROCEED);
                }
                widget.webViewModel.isSecure = false;
                updateGlobalWebViewModel();
                return ServerTrustAuthResponse(
                    action: ServerTrustAuthResponseAction.CANCEL);
              }
              return ServerTrustAuthResponse(
                  action: ServerTrustAuthResponseAction.PROCEED);
            },
            onLoadError: (controller, url, code, message) async {
              // 不支持的 scheme
              if (url != null && ['http', 'https'].indexOf(url.scheme) == -1) {
                logger.w('不支持的 URI Scheme: ${url.scheme}, URL: $url');
                if (await controller.canGoBack()) {
                  controller.goBack();
                }
                return;
              }
              // NSURLErrorDomain
              if (Platform.isIOS && code == -999) {
                return;
              }

              var errorUrl = url ??
                  widget.webViewModel.url ??
                  Uri.parse(WebViewModel.aboutBlankUrl);

              _webViewController?.loadData(
                data: """
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
      <meta http-equiv="X-UA-Compatible" content="ie=edge">
      <style>
      ${await _webViewController?.getTRexRunnerCss()}
      </style>
      <style>
      .interstitial-wrapper {
          box-sizing: border-box;
          font-size: 1em;
          line-height: 1.6em;
          margin: 0 auto 0;
          max-width: 600px;
          width: 100%;
      }
      </style>
    </head>
    <body>
      ${await _webViewController?.getTRexRunnerHtml()}
      <div class="interstitial-wrapper">
        <h1>Website not available</h1>
        <p>Could not load web pages at <strong>$errorUrl</strong> because:</p>
        <p>$message</p>
      </div>
    </body>
      """,
                baseUrl: errorUrl,
                androidHistoryUrl: errorUrl,
              );

              widget.webViewModel.url = url;
              widget.webViewModel.isSecure = false;
              updateGlobalWebViewModel();
            },
            onTitleChanged: (controller, title) async {
              widget.webViewModel.title = title;
              updateGlobalWebViewModel();
            },
            onCreateWindow: (controller, createWindowRequest) async {
              browserModel.addNewTab(windowId: createWindowRequest.windowId);
              return true;
            },
            onCloseWindow: (controller) {},
            androidOnPermissionRequest: (InAppWebViewController controller,
                String origin, List<String> resources) async {
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            },
            onReceivedHttpAuthRequest: (InAppWebViewController controller,
                URLAuthenticationChallenge challenge) async {
              var action = await createHttpAuthDialog(challenge);
              return HttpAuthResponse(
                  username: _httpAuthUsernameController.text.trim(),
                  password: _httpAuthPasswordController.text,
                  action: action,
                  permanentPersistence: true);
            },
          );
    return PageScaffold(
      bottomArea: _buildBottomArea(),
      body: renderWebview,
    );
  }

  Widget _buildBottomArea() {
    return Column(
      children: [
        _buildProgressIndicator(),
        bottom_bar.BottomBar(
          heroTag: widget.heroTag,
          mode: bottom_bar.BottomBarMode.webview,
          title:
              widget.webViewModel.title ?? widget.webViewModel.url.toString(),
          url: widget.webViewModel.url.toString(),
        ),
      ],
    );
  }

  // 构建加载指示器
  Widget _buildProgressIndicator() {
    return widget.webViewModel.progress >= 1.0
        ? Container()
        : ProgressBar(
            value: widget.webViewModel.progress,
          );
  }

  // 判断当前打开的 tab 是否为当前 tab
  bool isCurrentTab() {
    // 如果返回操作过快, 本方法有可能在 unmount 之后执行, 会提示拿不到 context
    if (!mounted) {
      return false;
    }
    var currentWebViewModel = Provider.of<WebViewModel>(context, listen: false);
    return currentWebViewModel.tabIndex == widget.webViewModel.tabIndex;
  }

  // 更新当前 webView model 到全局
  void updateGlobalWebViewModel() {
    if (isCurrentTab()) {
      var currentWebViewModel =
          Provider.of<WebViewModel>(context, listen: false);
      currentWebViewModel.updateWithValue(widget.webViewModel);
    }
  }

  Future<HttpAuthResponseAction> createHttpAuthDialog(
      URLAuthenticationChallenge challenge) async {
    HttpAuthResponseAction action = HttpAuthResponseAction.CANCEL;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(challenge.protectionSpace.host),
              TextField(
                decoration: InputDecoration(labelText: "Username"),
                controller: _httpAuthUsernameController,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Password"),
                controller: _httpAuthPasswordController,
                obscureText: true,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Cancel"),
              onPressed: () {
                action = HttpAuthResponseAction.CANCEL;
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Ok"),
              onPressed: () {
                action = HttpAuthResponseAction.PROCEED;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return action;
  }

  void onShowTab() {
    resume();
    if (widget.webViewModel.needsToCompleteInitialLoad) {
      widget.webViewModel.needsToCompleteInitialLoad = false;
      widget.webViewModel.webViewController
          ?.loadUrl(urlRequest: URLRequest(url: widget.webViewModel.url));
    }
  }

  void onHideTab() {
    pause();
  }
}
