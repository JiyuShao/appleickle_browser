// Copyright 2020 Lorenzo Pichilli
// Reference https://github.com/pichillilorenzo/flutter_browser_app/blob/master/lib/models/webview_model.dart
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
import 'dart:typed_data';
import 'package:collection/collection.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewModel extends ChangeNotifier {
  // 空页面的路由标识
  static String aboutBlankUrl = 'about:blank';

  int? _tabIndex;
  Uri? _url;
  String? _title;
  Favicon? _favicon;
  late double _progress;
  late bool _loaded;
  late bool _isDesktopMode;
  late bool _isIncognitoMode;
  late List<Widget> _javaScriptConsoleResults;
  late List<String> _javaScriptConsoleHistory;
  late List<LoadedResource> _loadedResources;
  late bool _isSecure;
  late bool _needsToCompleteInitialLoad;
  int? windowId;
  InAppWebViewGroupOptions? options;
  InAppWebViewController? webViewController;
  Uint8List? screenshot;

  WebViewModel({
    int? tabIndex,
    Uri? url,
    String? title,
    Favicon? favicon,
    double? progress,
    bool? loaded,
    bool? isDesktopMode,
    bool? isIncognitoMode,
    List<Widget>? javaScriptConsoleResults,
    List<String>? javaScriptConsoleHistory,
    List<LoadedResource>? loadedResources,
    bool? isSecure,
    bool? needsToCompleteInitialLoad,
    this.windowId,
    this.options,
    this.webViewController,
  }) {
    _tabIndex = tabIndex;
    _url = url;
    _title = title;
    _favicon = favicon;
    _progress = progress ?? 0.0;
    _loaded = loaded ?? false;
    _isDesktopMode = isDesktopMode ?? false;
    _isIncognitoMode = isIncognitoMode ?? false;
    _javaScriptConsoleResults = javaScriptConsoleResults ?? <Widget>[];
    _javaScriptConsoleHistory = javaScriptConsoleHistory ?? <String>[];
    _loadedResources = loadedResources ?? <LoadedResource>[];
    _isSecure = isSecure ?? false;
    _needsToCompleteInitialLoad = needsToCompleteInitialLoad ?? true;
    windowId = windowId;
    options = options ?? InAppWebViewGroupOptions();
    webViewController = webViewController;
    screenshot = screenshot;
  }

  // 重置数据
  reset() {
    _url = null;
    _progress = 0;
    _title = null;
    webViewController = null;
  }

  int? get tabIndex => _tabIndex;

  set tabIndex(int? value) {
    if (value != _tabIndex) {
      _tabIndex = value;
      notifyListeners();
    }
  }

  Uri? get url => _url;

  set url(Uri? value) {
    if (value != _url) {
      _url = value;
      notifyListeners();
    }
  }

  String? get title => _title;

  set title(String? value) {
    if (value != _title) {
      _title = value;
      notifyListeners();
    }
  }

  Favicon? get favicon => _favicon;

  set favicon(Favicon? value) {
    if (value != _favicon) {
      _favicon = value;
      notifyListeners();
    }
  }

  double get progress => _progress;

  set progress(double value) {
    if (value != _progress) {
      _progress = value;
      notifyListeners();
    }
  }

  bool get loaded => _loaded;

  set loaded(bool value) {
    if (value != _loaded) {
      _loaded = value;
      notifyListeners();
    }
  }

  bool get isDesktopMode => _isDesktopMode;

  set isDesktopMode(bool value) {
    if (value != _isDesktopMode) {
      _isDesktopMode = value;
      notifyListeners();
    }
  }

  bool get isIncognitoMode => _isIncognitoMode;

  set isIncognitoMode(bool value) {
    if (value != _isIncognitoMode) {
      _isIncognitoMode = value;
      notifyListeners();
    }
  }

  UnmodifiableListView<Widget> get javaScriptConsoleResults =>
      UnmodifiableListView(_javaScriptConsoleResults);

  setJavaScriptConsoleResults(List<Widget> value) {
    if (!IterableEquality().equals(value, _javaScriptConsoleResults)) {
      _javaScriptConsoleResults = value;
      notifyListeners();
    }
  }

  void addJavaScriptConsoleResults(Widget value) {
    _javaScriptConsoleResults.add(value);
    notifyListeners();
  }

  UnmodifiableListView<String> get javaScriptConsoleHistory =>
      UnmodifiableListView(_javaScriptConsoleHistory);

  setJavaScriptConsoleHistory(List<String> value) {
    if (!IterableEquality().equals(value, _javaScriptConsoleHistory)) {
      _javaScriptConsoleHistory = value;
      notifyListeners();
    }
  }

  void addJavaScriptConsoleHistory(String value) {
    _javaScriptConsoleHistory.add(value);
    notifyListeners();
  }

  UnmodifiableListView<LoadedResource> get loadedResources =>
      UnmodifiableListView(_loadedResources);

  setLoadedResources(List<LoadedResource> value) {
    if (!IterableEquality().equals(value, _loadedResources)) {
      _loadedResources = value;
      notifyListeners();
    }
  }

  void addLoadedResources(LoadedResource value) {
    _loadedResources.add(value);
    notifyListeners();
  }

  bool get isSecure => _isSecure;

  set isSecure(bool value) {
    if (value != _isSecure) {
      _isSecure = value;
      notifyListeners();
    }
  }

  bool get needsToCompleteInitialLoad => _needsToCompleteInitialLoad;

  set needsToCompleteInitialLoad(bool value) {
    if (value != _needsToCompleteInitialLoad) {
      _needsToCompleteInitialLoad = value;
      notifyListeners();
    }
  }

  void updateWithValue(WebViewModel webViewModel) {
    tabIndex = webViewModel.tabIndex;
    url = webViewModel.url;
    title = webViewModel.title;
    favicon = webViewModel.favicon;
    progress = webViewModel.progress;
    loaded = webViewModel.loaded;
    isDesktopMode = webViewModel.isDesktopMode;
    isIncognitoMode = webViewModel.isIncognitoMode;
    setJavaScriptConsoleResults(
        webViewModel._javaScriptConsoleResults.toList());
    setJavaScriptConsoleHistory(
        webViewModel._javaScriptConsoleHistory.toList());
    setLoadedResources(webViewModel._loadedResources.toList());
    isSecure = webViewModel.isSecure;
    options = webViewModel.options;
    webViewController = webViewModel.webViewController;
  }

  static WebViewModel? fromMap(Map<String, dynamic>? map) {
    return map != null
        ? WebViewModel(
            tabIndex: map["tabIndex"],
            url: map["url"] != null ? Uri.parse(map["url"]) : null,
            title: map["title"],
            favicon: map["favicon"] != null
                ? Favicon(
                    url: Uri.parse(map["favicon"]["url"]),
                    rel: map["favicon"]["rel"],
                    width: map["favicon"]["width"],
                    height: map["favicon"]["height"],
                  )
                : null,
            progress: map["progress"],
            isDesktopMode: map["isDesktopMode"],
            isIncognitoMode: map["isIncognitoMode"],
            javaScriptConsoleHistory:
                map["javaScriptConsoleHistory"]?.cast<String>(),
            isSecure: map["isSecure"],
            options: InAppWebViewGroupOptions.fromMap(map["options"]),
          )
        : null;
  }

  Map<String, dynamic> toMap() {
    return {
      "tabIndex": _tabIndex,
      "url": _url?.toString(),
      "title": _title,
      "favicon": _favicon?.toMap(),
      "progress": _progress,
      "isDesktopMode": _isDesktopMode,
      "isIncognitoMode": _isIncognitoMode,
      "javaScriptConsoleHistory": _javaScriptConsoleHistory,
      "isSecure": _isSecure,
      "options": options?.toMap(),
      "screenshot": screenshot,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
