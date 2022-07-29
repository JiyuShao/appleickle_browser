/*
 * 搜索组件
 * @Author: Jiyu Shao 
 * @Date: 2021-07-02 17:39:20 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2022-07-29 15:17:19
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appleickle_browser/models/browser_model.dart';
import 'package:appleickle_browser/screens/search/search_screen.dart';
import 'package:appleickle_browser/utils/logger.dart';
import 'package:appleickle_browser/models/app_theme_model.dart';
import 'package:appleickle_browser/utils/debounce.dart';

enum SearchBarKeyboardStatus {
  // 打开中
  opening,
  // 已打开
  opened,
  // 关闭中
  closing,
  // 已关闭
  closed,
}

enum SearchBarMode {
  // 正常搜索模式
  normal,
  // 在 bottomBar 中的模式
  bottomBar,
}

class SearchBar extends StatefulWidget {
  // 跳转到 search screen 的参数
  final SearchScreenArguments? searchScreenArguments;
  // 当前的展示模式
  final SearchBarMode mode;
  // 是否启用输入框
  final bool enabled;
  // 是否自动聚焦
  final bool autofocus;
  // 当前值
  final String initialValue;
  // 键盘显示回调事件
  final void Function(SearchBarKeyboardStatus keyboardStatus)?
      handleKeyboardChange;
  // 搜索回调事件
  final void Function(String searchText)? handleSearch;

  SearchBar({
    Key? key,
    required this.searchScreenArguments,
    this.mode = SearchBarMode.normal,
    // 输入框都是关闭, 点击跳向搜索页面
    this.enabled = false,
    this.autofocus = false,
    this.initialValue = '',
    this.handleKeyboardChange,
    this.handleSearch,
  }) : super(
          key: key,
        );

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> with WidgetsBindingObserver {
  // setState 之后防止键盘关闭, 设置 key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // input 控制器
  final TextEditingController _controller = TextEditingController();
  // debounce 使用的 key
  final Symbol _debounceKey = Symbol('SearchBar/handleKeyboardChangeDebounced');

  // 接收是否 focus 数据
  late final FocusNode _focusNode = FocusNode()
    ..addListener(() {
      // 触发刷新
      setState(() {});
    });

  // 键盘距离底部缓存
  double _lastKeyboardBottom = 0;
  // 键盘是否已打开缓存
  bool _lastIsKeyboardOpen = false;
  // 之前的初始值缓存
  String _previousInitialValue = '';

  @override
  void initState() {
    super.initState();
    // 添加键盘的监听
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.autofocus) {
      _focusOnTextField();
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _focusNode.dispose();
    // 取消键盘的监听
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (!widget.enabled) {
      return;
    }
    final currentKeyboardBottom = MediaQuery.of(context).viewInsets.bottom;
    // 如果键盘底部距离没有发生变化, 不作处理
    if (currentKeyboardBottom == _lastKeyboardBottom) {
      return;
    }
    final currentKeyboardOpen = currentKeyboardBottom > _lastKeyboardBottom;
    // 如果跟上次一样的话吗不需要重新触发回调
    if (currentKeyboardOpen != _lastIsKeyboardOpen) {
      _lastIsKeyboardOpen = currentKeyboardOpen;
      _handleKeyboardChange(currentKeyboardOpen
          ? SearchBarKeyboardStatus.opening
          : SearchBarKeyboardStatus.closing);
    }
    _lastKeyboardBottom = currentKeyboardBottom;

    // 这里一直触发防抖回调, 只有最后一次才会触发, 所以代码动画已完成
    _handleKeyboardChangeDebounced(currentKeyboardOpen
        ? SearchBarKeyboardStatus.opened
        : SearchBarKeyboardStatus.closed);
  }

  @override
  Widget build(BuildContext context) {
    BrowserModel browserModel =
        Provider.of<BrowserModel>(context, listen: true);
    BrowserSettingsModel settings = browserModel.getSettings();
    var themeData = Theme.of(context);
    // 如果是底部导航栏模式的话, 更改显示样式
    var constraints = BoxConstraints();
    var borderRadius = BorderRadius.circular(16);
    var inputContentPadding =
        EdgeInsets.symmetric(vertical: 17.0, horizontal: 14.0);
    var textStyle = themeData.textTheme.bodyText1;
    var textAlign = TextAlign.start;
    // prefixIcon 图片大小需要用到 padding
    // https://api.flutter.dev/flutter/material/InputDecoration/prefixIcon.html
    GestureDetector? prefixIcon = GestureDetector(
      onTap: () {
        browserModel.useNextSearchEngine();
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(
          settings.searchEngine.assetIcon,
          height: 20,
          width: 20,
        ),
      ),
    );
    if (widget.mode == SearchBarMode.bottomBar) {
      constraints = BoxConstraints(maxHeight: 35);
      borderRadius = BorderRadius.circular(11);
      inputContentPadding = EdgeInsets.symmetric(vertical: 0, horizontal: 14.0);
      textStyle = themeData.textTheme.caption;
      textAlign = TextAlign.center;
      prefixIcon = null;
    }

    // 根据传入的初始值更新当前输入的值
    _checkPropsUpdate();

    return Container(
        decoration: _focusNode.hasFocus
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 20,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ])
            : null,
        child: GestureDetector(
          // 如果 TextField enable 为 false 的情况下, 并不会触发该回调
          onTap: _handleTap,
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: constraints,
              child: TextField(
                key: _formKey,
                focusNode: _focusNode,
                controller: _controller,
                enabled: widget.enabled,
                autofocus: false,
                textInputAction: TextInputAction.go,
                onTap: _handleTap,
                onSubmitted: (_) {
                  _handleSearch();
                },
                showCursor: true,
                cursorWidth: 2.8,
                cursorRadius: Radius.circular(2.0),
                style: textStyle,
                textAlign: textAlign,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: themeData.backgroundColor,
                  contentPadding: inputContentPadding,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide:
                        BorderSide(width: 2.5, color: themeData.hintColor),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide:
                        BorderSide(width: 2.5, color: themeData.hintColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide:
                        BorderSide(width: 2.5, color: themeData.primaryColor),
                  ),
                  prefixIcon: prefixIcon,
                  suffixIcon: widget.enabled
                      ? GestureDetector(
                          onTap: () {
                            _handleSearch();
                          },
                          child: Icon(
                            Icons.search,
                            size: 30,
                            color: _focusNode.hasFocus
                                ? themeData.primaryColor
                                : themeData.hintColor,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
        ));
  }

  // 检查传入的参数是否发生更改
  void _checkPropsUpdate() {
    // 如果初始化的值发生更改, 则可以更新 input 当前值
    if (_previousInitialValue != widget.initialValue &&
        widget.initialValue.isNotEmpty) {
      _controller.text = widget.initialValue;
      _previousInitialValue = widget.initialValue;
    }
  }

  // 处理点击事件
  void _handleTap() {
    if (ModalRoute.of(context)!.settings.name != SearchScreen.routeName) {
      Navigator.of(context).pushNamed(SearchScreen.routeName,
          arguments: widget.searchScreenArguments);
    }
  }

  // 处理搜索事件
  void _handleSearch() {
    var currentValue = _controller.text;
    loggerNoStack.d('SearchBar.__handleSearch: $currentValue');
    if (widget.handleSearch != null && currentValue.isNotEmpty)
      widget.handleSearch!(currentValue);
    _focusNode.unfocus();
  }

  // 异步的聚焦输入框, 不然会跟 Hero 动画冲突
  void _focusOnTextField() async {
    await Future.delayed(
      Duration(milliseconds: AppThemeModel.baseAnimationDuration),
    );
    if (!_focusNode.hasFocus) _focusNode.requestFocus();
  }

  // 键盘更改回调封装
  void _handleKeyboardChange(SearchBarKeyboardStatus keyboardStatus) {
    if (widget.handleKeyboardChange == null) {
      return;
    }
    widget.handleKeyboardChange!(keyboardStatus);
  }

  // 键盘更改回调防抖封装
  void _handleKeyboardChangeDebounced(SearchBarKeyboardStatus keyboardStatus) {
    Debounce.debounce(_debounceKey, Duration(milliseconds: 50),
        () => _handleKeyboardChange(keyboardStatus));
  }
}
