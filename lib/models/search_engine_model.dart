// Copyright 2020 Lorenzo Pichilli
// Reference https://github.com/pichillilorenzo/flutter_browser_app/blob/master/lib/models/search_engine_model.dart
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
class SearchEngineModel {
  final String name;
  final String assetIcon;
  final String url;
  final String searchUrl;

  const SearchEngineModel(
      {required this.name,
      required this.url,
      required this.searchUrl,
      required this.assetIcon});

  static SearchEngineModel? fromMap(Map<String, dynamic>? map) {
    return map != null
        ? SearchEngineModel(
            name: map["name"],
            assetIcon: map["assetIcon"],
            url: map["url"],
            searchUrl: map["searchUrl"])
        : null;
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "assetIcon": assetIcon,
      "url": url,
      "searchUrl": searchUrl
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

const BingSearchEngine = const SearchEngineModel(
    name: "Bing",
    url: "https://www.bing.com/",
    searchUrl: "https://www.bing.com/search?q=",
    assetIcon: "assets/images/search_engine/bing_logo.png");

const BaiduSearchEngine = const SearchEngineModel(
    name: "Baidu",
    url: "https://www.baidu.com/",
    searchUrl: "https://www.baidu.com/s?wd=",
    assetIcon: "assets/images/search_engine/baidu_logo.png");

const GoogleSearchEngine = const SearchEngineModel(
    name: "Google",
    url: "https://www.google.com/",
    searchUrl: "https://www.google.com/search?q=",
    assetIcon: "assets/images/search_engine/google_logo.png");

const YahooSearchEngine = const SearchEngineModel(
    name: "Yahoo",
    url: "https://yahoo.com/",
    searchUrl: "https://search.yahoo.com/search?p=",
    assetIcon: "assets/images/search_engine/yahoo_logo.png");

const DuckDuckGoSearchEngine = const SearchEngineModel(
    name: "DuckDuckGo",
    url: "https://duckduckgo.com/",
    searchUrl: "https://duckduckgo.com/?q=",
    assetIcon: "assets/images/search_engine/duckduckgo_logo.png");

const EcosiaSearchEngine = const SearchEngineModel(
    name: "Ecosia",
    url: "https://www.ecosia.org/",
    searchUrl: "https://www.ecosia.org/search?q=",
    assetIcon: "assets/images/search_engine/ecosia_logo.png");

const SearchEngines = <SearchEngineModel>[
  BingSearchEngine,
  BaiduSearchEngine,
  GoogleSearchEngine,
  YahooSearchEngine,
  DuckDuckGoSearchEngine,
  EcosiaSearchEngine
];
