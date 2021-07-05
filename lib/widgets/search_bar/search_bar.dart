/*
 * 搜索组件
 * @Author: Jiyu Shao 
 * @Date: 2021-07-02 17:39:20 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-05 10:37:53
 */
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  // 是否启用输入框
  final bool enabled;

  SearchBar({Key? key, this.enabled = true})
      : super(
          key: key,
        );

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  // setState 之后防止键盘关闭, 设置 key
  late GlobalKey<FormState> _formKey;
  // 接收是否 focus 数据
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _formKey = new GlobalKey<FormState>();
    _focusNode = FocusNode()
      ..addListener(() {
        // 触发刷新
        setState(() {});
        // Timer(Duration(seconds: 1), () {
        //   if (_focusNode.hasFocus) _focusNode.unfocus();
        // });
      });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _focusNode.dispose();
    super.dispose();
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
              onTap: _handleTap,
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

  void _handleTap() {
    if (ModalRoute.of(context)!.settings.name != '/search') {
      Navigator.of(context).pushNamed('/search');
    }
  }
}
