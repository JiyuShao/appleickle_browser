/*
 * TRex 游戏页面
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 17:53:00 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-10-23 13:11:12
 */
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:appleickle_browser/widgets/page_scaffold/page_scaffold.dart';
import 'package:appleickle_browser/widgets/trex_game/game.dart';

class TRexGameScreen extends StatefulWidget {
  // 路由名称
  static const routeName = '/trex_game_screen';
  @override
  _TRexGameScreenState createState() => _TRexGameScreenState();
}

class _TRexGameScreenState extends State<TRexGameScreen> {
  bool splashGone = false;
  TRexGame? game;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  // 加载元素并开始游戏
  void startGame() {
    Flame.images.loadAll(["trex_game/sprite.png"]).then(
      (image) => {
        setState(() {
          game = TRexGame(spriteImage: image[0]);
          _focusNode.requestFocus();
        })
      },
    );
  }

  // 触发游戏操作
  void triggerGameAction() {
    game?.onAction();
  }

  // 监听键盘输入
  void onRawKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      triggerGameAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (game == null) {
      return Container(
        color: Colors.white,
      );
    }
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: onRawKeyEvent,
      child: GestureDetector(
        onTap: triggerGameAction,
        child: PageScaffold(
          body: GameWidget(
            game: game!,
          ),
        ),
      ),
    );
  }
}
