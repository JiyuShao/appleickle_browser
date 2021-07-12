/*
 * 搜索组件
 * @Author: Jiyu Shao 
 * @Date: 2021-07-02 17:39:20 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-12 10:35:42
 */
import 'package:appleickle_browser/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
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

class SearchBar extends StatefulWidget {
  // Hero 动画相关 tag
  final String heroTag;
  // 是否启用输入框
  final bool enabled;
  // 是否自动聚焦
  final bool autofocus;
  // 键盘显示回调事件
  final void Function(SearchBarKeyboardStatus keyboardStatus)?
      handleKeyboardChange;
  // 搜索回调事件
  final void Function(String searchText)? handleSearch;

  SearchBar(
      {Key? key,
      required this.heroTag,
      this.enabled = true,
      this.autofocus = false,
      this.handleKeyboardChange,
      this.handleSearch})
      : super(
          key: key,
        );

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> with WidgetsBindingObserver {
  // setState 之后防止键盘关闭, 设置 key
  late final GlobalKey<FormState> _formKey;
  // 接收是否 focus 数据
  late final FocusNode _focusNode;
  // debounce 使用的 key
  late final Symbol _debounceKey;
  // 键盘距离底部缓存
  double _lastKeyboardBottom = 0;
  // 键盘是否已打开缓存
  bool _lastIsKeyboardOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _formKey = new GlobalKey<FormState>();
    _focusNode = FocusNode()
      ..addListener(() {
        // 触发刷新
        setState(() {});
      });
    _debounceKey = Symbol('SearchBar/handleKeyboardChangeDebounced');
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
    WidgetsBinding.instance!.removeObserver(this);
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
    return AnimatedContainer(
        duration: Duration(seconds: 5),
        decoration: _focusNode.hasFocus
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(0.4),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ])
            : null,
        child: GestureDetector(
          // 如果 TextField enable 为 false 的情况下, 并不会触发该回调
          onTap: _handleTap,
          child: Material(
            color: Colors.transparent,
            child: TextField(
              key: _formKey,
              focusNode: _focusNode,
              enabled: widget.enabled,
              autofocus: false,
              textInputAction: TextInputAction.search,
              onTap: _handleTap,
              onSubmitted: _handleSearch,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).backgroundColor,
                contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 17.0, top: 17.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(
                      width: 2.5, color: Theme.of(context).hintColor),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(
                      width: 2.5, color: Theme.of(context).hintColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(
                      width: 2.5, color: Theme.of(context).primaryColor),
                ),
                suffixIcon: Icon(
                  Icons.search,
                  size: 30,
                  color: _focusNode.hasFocus
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).hintColor,
                ),
              ),
            ),
          ),
        ));
  }

  // 处理点击事件
  void _handleTap() {
    if (ModalRoute.of(context)!.settings.name != SearchScreen.routeName) {
      Navigator.of(context).pushNamed(SearchScreen.routeName,
          arguments: SearchScreenArguments(heroTag: widget.heroTag));
    }
  }

  // 处理搜索事件
  void _handleSearch(String value) {
    print('_handleSearch $value');
    if (widget.handleSearch != null) widget.handleSearch!(value);
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
